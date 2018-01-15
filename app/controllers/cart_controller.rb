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

  def add_gift_code
    promo = Gift.find_by(code: params['promo_code'])
    cart = Cart.find(params['cart_id'])

    if !promo
      render json: {code: 1000}.to_json
    elsif promo.used
      render json: {code: 1001}.to_json
    elsif promo.limit_usage <= 0
      promo.used = true
      promo.save
      render json: {code: 1002}.to_json
    elsif Time.now > promo.time_available
      render json: {code: 1003}.to_json
    elsif cart.promotion_codes.size == 1
      render json: {code: 1004}.to_json
    elsif cart.gifts.size == 1
      render json: {code: 1004}.to_json
    else
      cart.gifts << promo
      promo.limit_usage = promo.limit_usage - 1
      promo.save
      render json: {code: 1005}.to_json
    end
  end

  def create

    user = TempUser.find_by_email(params['cardholder-email'])

    if user
      partial_user = TempUser.find(session[:temp_user_id])
      session[:temp_user_id] = user.id
      user.cart = partial_user.cart
    else
      user = TempUser.find(session[:temp_user_id])
      user.email = params['cardholder-email']
    end
    user.save!

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

    tax_array = []
    cost_array = []
    cart = get_cart

    cart.cart_products.each do |product|
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

    charge = nil
    order = nil
    begin

      amount = cost_t + tax_t
      promo_code = get_cart.promotion_codes.first
      promo_code_g = get_cart.gifts.first

      if promo_code && promo_code_g
        amount = amount - (amount * ((promo_code.rate + promo_code_g.rate) / 100))
      elsif promo_code
        amount = amount - (amount * (promo_code.rate / 100))
      elsif promo_code_g
        amount = amount - (amount * (promo_code_g.rate / 100))
      end

      token = params[:token][:id]
      charge = Stripe::Charge.create(
          :amount => (amount * 100).to_i,
          :currency => "usd",
          :description => "Example charge",
          :source => token,
          )

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

        ca = ChangeAuthor.create do |c|
          c.email = params['cardholder-email']
          c.code_authenticity = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
          c.used = false
          c.limit = Time.now + 2.hours
        end
        ca.save!

        user.user_address.order = order
        user.user_address.save!

      end
    rescue Stripe::CardError => e
      charge = e.json_body[:error]
    end
    render :json => {charge: charge, order: order, ca: ca.code_authenticity}.to_json.html_safe, :code => 200
  end

  def change_order_manager
    order = Order.find params[:order]
    author_privilege = ChangeAuthor.find_by_code_authenticity params[:code_authenticity]
    first_author = order.overall_user
    if author_privilege
      if (author_privilege.email == first_author.email) && !author_privilege.used && Time.now < author_privilege.limit
        begin
          first_author.orders.delete order

          n_user = TempUser.find_by_email(params[:n_mail]) || TempUser.create
          n_user.email = params[:n_mail]
          session[:temp_user_id] = n_user.id
          n_user.save!

          n_user.orders << order
          author_privilege.used = true
          author_privilege.save!

          ca = ChangeAuthor.create do |c|
            c.email = params['n_mail']
            c.code_authenticity = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
            c.used = false
            c.limit = Time.now + 2.hours
          end
          ca.save!

          render json: {order_id: params[:order], auth_code: ca.code_authenticity}.to_json, status: :ok

        rescue

          ca = ChangeAuthor.create do |c|
            c.email = params['n_mail']
            c.code_authenticity = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
            c.used = false
            c.limit = Time.now + 2.hours
          end
          ca.save!

          render json: {order_id: params[:order], auth_code: ca.code_authenticity}.to_json, status: :conflict
        end
      else
        render json: {}, status: :forbidden
      end
    else
      render json: {}, status: :forbidden
    end
  end

  def mail_token
    user = TempUser.find session[:temp_user_id]
    mail = TUserTokenRequestMailer.new_token_request(user, request.host, request.port)
    mail.deliver_now
  end

  def add_promo_code
    promo = PromotionCode.find_by(code: params['promo_code'])
    cart = Cart.find(params['cart_id'])

    if !promo
      render json: {code: 1000}.to_json
    elsif promo.used
      render json: {code: 1001}.to_json
    elsif promo.limitUsage <= 0
      promo.used = true
      promo.save
      render json: {code: 1002}.to_json
    elsif Time.now > promo.timeAvailable
      render json: {code: 1003}.to_json
    elsif cart.promotion_codes.size == 1
      render json: {code: 1004}.to_json
    elsif cart.gifts.size == 1
      render json: {code: 1004}.to_json
    else
      cart.promotion_codes << promo
      promo.limitUsage = promo.limitUsage - 1
      promo.save
      render json: {code: 1005}.to_json
    end

  end

  def remove_promo_code
    cart = get_cart
    promo = cart.promotion_codes.first
    if promo
      promo.limitUsage = promo.limitUsage + 1
      promo.save!
      cart.promotion_codes.clear
    end
  end

  def remove_gift_code
    cart = get_cart
    gift = cart.gifts.first
    if gift
      gift.limit_usage = gift.limit_usage + 1
      gift.save!
      cart.gifts.clear
    end
  end

end
