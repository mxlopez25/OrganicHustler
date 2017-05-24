require 'rest-client'

class AdminController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!

  def main
  end

  def products
  end

  def logo
  end

  def orders
  end

  def mailer
  end

  def order_search
    id = params['search-field']
    render '/admin/orders'
  end

  def order_details
    id_o = params['id_o']
    @order = Order.find(id_o)
    render '/admin/orders_functions/order_details'
  end

  def mailer_send
    subject = params['subject']
    content = params['editor'].html_safe
    Subscriber.all.each do |user|
      mail = SubscriptionMailer.new_promotion(user.email, subject, content)
      mail.deliver_now
    end
  end

  def new_product
    render 'admin/products_functions/new_product'
  end

  def info_product
    @product = AdminHelper.get_product_by_id(params[:id])
    render 'admin/products_functions/info_product'
  end

  def edit_product
    @product = AdminHelper.get_product_by_id(params[:id])
    render 'admin/products_functions/edit_product'
  end

  def modify_variation
    @id = params['variation_id']
    @product = params['source_product']
    render 'admin/products_functions/modify_variation'
  end

  def add_variation
    p params
    @product_id = params['source_product']
    if request.method.eql?('GET')
      @modifiers = []
      AdminHelper.get_product_by_id(@product_id)['modifiers'].each do |modifiers|
        @modifiers.push(modifiers)
      end
      render 'admin/products_functions/add_variation'
    elsif request.method.eql?('POST')
      p params['var_s']
      case params['var_s']
        when "0"
          object = "{\"image_id\": \"#{params['id_pic']}\", \"x\": \"#{params['pos-x']}\", \"y\": \"#{params['pos-y']}\", \"width\": \"#{params['width-p']}\", \"height\": \"#{params['height-p']}\", \"s_w\": \"#{params['source_w']}\", \"s_h\": \"#{params['source_h']}\"}"
          RestClient.post("https://api.molt.in/v1/products/#{@product_id}/modifiers/#{params['modifier']}/variations", {title: object, mod_price: '+0'}, {:Authorization => "Bearer #{AdminHelper.generate_token}"})
        when "1"
          RestClient.post("https://api.molt.in/v1/products/#{@product_id}/modifiers/#{params['modifier']}/variations", {title: params['changes'], mod_price: "#{params['sign']}#{params['price_mod']}"}, {:Authorization => "Bearer #{AdminHelper.generate_token}"})
        when "2"
          object = "{\"code\": \"#{params['favcolor']}\", \"title\": \"#{params['changes']}\"}"
          RestClient.post("https://api.molt.in/v1/products/#{@product_id}/modifiers/#{params['modifier']}/variations", {title: object, mod_price: "#{params['sign']}#{params['price_mod']}"}, {:Authorization => "Bearer #{AdminHelper.generate_token}"})
        when "3"
          RestClient.post("https://api.molt.in/v1/products/#{@product_id}/modifiers/#{params['modifier']}/variations", {title: params['changes'], mod_price: "#{params['sign']}#{params['price_mod']}"}, {:Authorization => "Bearer #{AdminHelper.generate_token}"})
        when "4"
          RestClient.post("https://api.molt.in/v1/products/#{@product_id}/modifiers/#{params['modifier']}/variations", {title: params['changes'], mod_price: "#{params['sign']}#{params['price_mod']}"}, {:Authorization => "Bearer #{AdminHelper.generate_token}"})
        else
          # type code here
      end

      @product = AdminHelper.get_product_by_id(@product_id)

      render 'admin/products_functions/edit_product'
    end
  end

end
