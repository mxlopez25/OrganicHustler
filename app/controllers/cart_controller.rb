require 'stripe'
class CartController < ApplicationController
  include HomeHelper
  Stripe.api_key = ENV['STRIPE_SECRET']

  after_filter :store_action

  def store_action
    return unless request.get?
    if request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr? # don't store ajax calls
      store_location_for(:user, request.fullpath)
    end
  end

  def new
    c_id_stripe = get_user_toc['c_stripe_id']

    if c_id_stripe
      customer = Stripe::Customer.retrieve(c_id_stripe)
      @card = customer.sources.retrieve(customer['default_source'])
    end
  end

  def create

    user = nil
    unsigned_user = false

    if user_signed_in?
      user = current_user
    else
      if User.find_by_email(params['cardholder-email'])
        unsigned_user = true
        render json: {sign: 'required'}.to_json.html_safe
      else
        user = TempUser.find_by_email(params['cardholder-email'])

        if user
          partial_user = TempUser.find(session[:temp_user_id])
          session[:temp_user_id] = user.id
          user.cart = partial_user.cart
          user.save!
        else
          user = TempUser.find(session[:temp_user_id])
          user.email = params['cardholder-email']
          user.save!
        end

        user_address = {
            :street_address => params['cardholder-street'],
            :city => params['cardholder-city'],
            :state => params['cardholder-state'],
            :zip_code => params['cardholder-zip'],
            :area => params['cardholder-area'],
            :number => params['cardholder-number']
        }

        user.create_user_address(user_address)
        user.save!
        mail = TUserTokenRequestMailer.new_token_request(user, request.host, request.port)
        mail.deliver_now
      end
    end

    unless unsigned_user
      tax_array = []
      cost_array = []
      cart_id = user.cart.id

      CartProduct.where(cart_id: cart_id).each do |product|
        pr_price = product_price(product.id)
        tax_array.push(pr_price[1])
        cost_array.push(pr_price[5])
      end

      cost_t = 0
      cost_array.each do |cost|
        cost_t = cost_t + cost
      end

      tax_t = 0
      tax_array.each do |tax|
        tax_t = tax_t + tax
      end

      token = params[:token][:id]

      if params['save_cr'].eql?('on')
        customer = Stripe::Customer.create(email: user.email, source: token)
        user.c_stripe_id = customer.id
        user.save!
      end

      charge = ''
      begin
        charge = nil

        if user['c_stripe_id']
          charge = Stripe::Charge.create(
              :amount => ((cost_t + tax_t)*100).to_i,
              :currency => "usd",
              :description => "Example charge",
              :customer => user.c_stripe_id,
          )
        else
          p ((cost_t + tax_t)*100).to_i
          charge = Stripe::Charge.create(
              :amount => ((cost_t + tax_t)*100).to_i,
              :currency => "usd",
              :description => "Example charge",
              :source => token,
          )
        end

        cart = Cart.find(cart_id)

        unless charge[:status].eql?('failed')
          order = Order.create do |t|
            t.cart = cart
            t.description = 'Order is being processed'
            t.state = 'Processing'
            t.charge_id = charge.id
            t.user_address_id = user.user_address.id
          end

          user.orders << order
          user.cart = nil
          user.save!

        end

      rescue Stripe::CardError => e
        charge = e.json_body[:error]
      end
      render :json => charge.to_json.html_safe
    end
  end

end
