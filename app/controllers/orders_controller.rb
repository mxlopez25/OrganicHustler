require 'easypost'
class OrdersController < ApplicationController
  EasyPost.api_key = ENV['EASYPOST_SECRET']

  layout 'admin'
  before_action :authenticate_admin!

  def order_params(order_params)
    order_params.permit(:state, :description)
  end

  def update
    (Order.find params['order_id']).update!(order_params(params['order']))
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
        name: params['client_name'],
        company: 'Vandelay Industries',
        street1: '1 E 161st St.',
        city: 'Bronx',
        state: 'NY',
        zip: '10451'
    )

    parcel = EasyPost::Parcel.create(
        length: 9,
        width: 6,
        height: 2,
        weight: 10
    )

    shipment = EasyPost::Shipment.create(
        to_address: to_address,
        from_address: from_address,
        parcel: parcel
    )

    shipment.rates.each do |rate|
      puts(rate.carrier)
      puts(rate.service)
      puts(rate.rate)
      puts(rate.id)
    end

    shipment.buy(
        rate: shipment.lowest_rate(carriers = ['USPS'], services = ['First'])
    )

    render :json => {url: shipment.postage_label.label_url}.to_json
  end

end