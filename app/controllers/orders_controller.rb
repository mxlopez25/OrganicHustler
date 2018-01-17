require 'easypost'
class OrdersController < ApplicationController
  EasyPost.api_key = ENV['EASYPOST_SECRET']

  layout 'admin'
  before_action :authenticate_admin!

  def update

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
        height:  params['h'],
        weight:  params['w_o']
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

end