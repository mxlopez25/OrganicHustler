require 'stripe'
class CartController < ApplicationController
  include HomeHelper
  Stripe.api_key = ENV['STRIPE_SECRET']

  def new

    c_id_stripe = get_user_toc['c_stripe_id']

    if c_id_stripe
      customer = Stripe::Customer.retrieve(c_id_stripe)
      @card = customer.sources.retrieve(customer['default_source'])
    end
  end

  def create

    user = nil

    if user_signed_in?
      user = current_user
    else
      user = TempUser.find(session[:temp_user_id])
      user.email = params['cardholder-email']
      user.save!

      mail = TUserTokenRequestMailer.new_token_request(user)
      mail.deliver_now
    end

    tax_array = []
    cost_array = []
    cart_id = get_cart_id

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
