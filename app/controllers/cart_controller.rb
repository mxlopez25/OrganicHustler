class CartController < ApplicationController
  include HomeHelper
  Stripe.api_key = ENV['STRIPE_SECRET']

  def new

  end

  def create
    p params

    tax_array = []
    cost_array = []

    CartProduct.where(cart_id: get_cart_id).each do |product|
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

      Order.create! do |t|
        
      end

    rescue Stripe::CardError => e
      charge = e.json_body[:error]
    rescue => e
      charge = e.message
    end

    render :json => charge.to_json.html_safe
  end

end
