class CartController < ApplicationController
  include HomeHelper
  Stripe.api_key = ENV['STRIPE_SECRET']

  def new

  end

  def create
    p params
    user = nil

    if user_signed_in?
      user = current_user
    else
      user = TempUser.find(session[:temp_user_id])
    end

    tax_array = []
    cost_array = []
    cart_id = get_cart_id

    CartProduct.where(cart_id: cart_id).each do |product|
      pr_price = get_p_price(product.m_id, product.logo_id, product.emblem_id, product.size_price)
      tax_array.push(pr_price[1])
      cost_array.push(pr_price[0])
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

    charge = ''
    begin
      charge = Stripe::Charge.create(
          :amount => ((cost_t + tax_t)*100).to_i,
          :currency => "usd",
          :description => "Example charge",
          :source => token,
      )

      unless charge[:status].eql?('failed')
        order = Order.create do |t|
          t.cart = Cart.find(cart_id)
          t.total = cost_t + tax_t
          t.description = 'Order is being processed'
          t.state = 'Processing'
        end

        user.orders << order
        user.save!

      end

    rescue Stripe::CardError => e
      charge = e.json_body[:error]
    rescue => e
      charge = e.message
      p e.message
    end

    render :json => charge.to_json.html_safe
  end

end
