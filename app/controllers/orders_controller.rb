require 'easypost'
class OrdersController < ApplicationController
  EasyPost.api_key = ENV['EASYPOST_SECRET']

  layout 'admin'
  before_action :authenticate_admin!

  def update

  end

  def destroy
    id_order = params[:id_order]
    id_product_cart = params[:id_product_cart]

    order_a = Order.find(id_order)
    if order_a
      if order_a.tag_link
        begin
          p order_a
          shipment = EasyPost::Shipment.retrieve(order_a.tag_link)
          shipment.refund

          unless order_a.state.eql?('Shipped')
            p order_a, '################'
            refund(order_a, id_product_cart)
            if id_product_cart
              cart_a = order_a.cart
              product = cart_a.cart_products.find(id_product_cart)
              product.state = 'Cancelled'
              product.save!
            else

              order_a.state = 'Cancelled'
              order_a.save!
            end
          end
        rescue => e
          render json: {error: e}, status: :unauthorized
        end
      else
        unless order_a.state.eql?('Shipped')
          p order_a
          refund(order_a, id_product_cart)
          if id_product_cart
            cart_a = order_a.cart
            product = cart_a.cart_products.find(id_product_cart)
            product.state = 'Cancelled'
            product.save!
          else
            order_a.state = 'Cancelled'
            order_a.save!
          end
        end
      end
    end
  end

  def complete
    order = Order.find params[:id_order]
    order.confirmed = !order.confirmed
    order.save!
  end

  def cancel_shipment
    order = Order.find params[:order_id]
    shipment = EasyPost::Shipment.retrieve(order.tag_link)
    begin
      shipment.refund
      order.shipping_tag_histories << ShippingTagHistory.create!(easy_post_id: shipment.id)
      order.tag_link = nil
      order.save!
      render json: {message: 'successful'}, status: :ok
    rescue => e
      render json: {error: e}, status: :unauthorized
    end
  end

  def get_tag

    order = Order.find(params['order'])
    addres = order.user_address
    user = order.overall_user

    from_address = EasyPost::Address.create(
        company: 'EasyPost',
        street1: '417 Montgomery Street',
        street2: '5th Floor',
        city: 'San Francisco',
        state: 'CA',
        zip: '94104',
        phone: '415-528-7555'
    )

    to_address = EasyPost::Address.create(
        name: '',
        company: 'Vandelay Industries',
        street1: '1 E 161st St.',
        street2: '',
        city: 'Bronx',
        state: 'NY',
        zip: '10451'
    )

    parcel = EasyPost::Parcel.create(
        length: params['l'],
        width: params['w'],
        height: params['h'],
        weight: params['w_o']
    )

    shipment = EasyPost::Shipment.create(
        to_address: to_address,
        from_address: from_address,
        parcel: parcel
    )

    shipment.buy(
        rate: shipment.lowest_rate(carriers = ['USPS'], services = ['First'])
    )
    order.tag_link = shipment.id
    order.carrier = 'USPS'
    order.tracking_code = shipment.tracker.tracking_code
    order.save!

    render :json => {url: shipment.postage_label.label_url}.to_json
  end

  private

  def self.refund(order, item = nil)
    if item.nil?
      Stripe::Refund.create(:charge => order.charge_id)
    else
      amount = ApplicationHelper.product_price(item)[6]
      cart = order.cart

      promo = cart.promotion_codes.first
      gift = cart.gifts.first

      p promo, gift, cart

      if promo
        amount = amount - (amount * (promo.rate / 100))
      end

      if gift
        amount = amount - (amount * (gift.rate / 100))
      end

      p amount, '###############################', ApplicationHelper.product_price(item)

      Stripe::Refund.create(:charge => order.charge_id, :amount => HomeController.to_integer(100 * amount))
    end
  end

end