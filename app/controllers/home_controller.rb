require 'json'
require 'rest_client'
class HomeController < ApplicationController
  include AdminHelper
  include CartHelper

  before_action :authenticate_user!, only: 'account'

  def index
  end

  def colored_image
    pr_id = params['pr_id']
    mod = params['mod']
    actual_id = params['act_obj']

    variations_obj = {}

    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/#{pr_id}/variations", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
    result = JSON.parse(response.body)['result']
    result.each do |r|
      variations_obj[(r['modifiers'][mod]['var_id'])] = [r['id'].eql?(actual_id), "#{r['id']}"]
    end

    render json: variations_obj.to_json

  end

  def catalog_item
    al = HomeHelper.get_product_by_id(params['id']).as_json
    al['variation_pp'] = false
    al['source_p'] = params['id']
    al['product_id_e'] = params['id']
    if al['is_variation']
      al['source_p'] = al['modifiers'].first[1]['product']
      response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/#{al['source_p']}", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
      al['modifiers'] = JSON.parse(response.body)['result']['modifiers']
    end
    if params['variation_ma'].eql?('false')
      al['variation_pp'] = true
      al['image_id'] = params['logo_id']
      al['width_u'] = params['width']
      al['height_u'] = params['height']
      al['x_u'] = params['dim_x']
      al['y_u'] = params['dim_y']
      al['s_w'] = params['relation_x']
      al['s_h'] = params['relation_y']
      al['has_image'] = params['has_logo']
      al['has_emblem'] = params['has_emblem']
      al['emblem_id'] = params['emblem_id']
      al['position_id'] = params['position_id']
    end
    p al
    render :json => al.to_json
  end

  def catalog
    @open_quick_m
    p @open_quick_m
    @parameters = params
  end

  def product
    @product = HomeHelper.get_product_by_id(params[:id])
    @parameters = params
  end

  def account
    @address = current_user.user_address
    unless @address
      @address = current_user.create_user_address
    end
  end

  def bag

  end

  def temp_user_act

  end

  def temp_user_menu

  end

  def temp_user_order

    if request.get?

      tuc = TempUserControl.find_by_ip_address(request.env['REMOTE_ADDR'])
      if tuc
        p tuc.to_json, session['temp_token']
        @user = nil
        if tuc.t_available > Time.now && tuc.auth_token.eql?(session['temp_token'])
          @user = TempUser.find(tuc.temp_user_id)
        end
      end

    elsif request.post?
      begin
        temp_user_c = TempUserControl.where(auth_token: request.env['HTTP_AUTHORIZATION'], valid_token: 1).first
        if temp_user_c
          @user = TempUser.find(temp_user_c.temp_user_id)
          temp_user_c.ip_address = request.env['REMOTE_ADDR']
          temp_user_c.valid_token = false
          session['temp_token'] = request.env['HTTP_AUTHORIZATION']
          temp_user_c.save!
        end
      rescue => e
        p e
      end
    end
  end

  def send_verification

    user = TempUser.find_by_email(params['email'])

    mail = TUserTokenRequestMailer.new_token_request(user, request.host, request.port)
    mail.deliver_now
  end

  def get_image_by_id
    render text: Picture.find(params[:id]).image.url(params[:style])
  end

  def get_logos_by_id

    logos = []
    Gallery.where(product_id: params['id']).first.pictures.all.each do |logo|
      logo_rt = {
          url: [logo.image.url(:large), logo.image.url(:thumb)],
          id: logo.id
      }
      logos.push(logo_rt)
    end

    render json: logos.to_json
  end

  def add_to_cart
    user = nil
    p current_user
    if params['user_signed'].eql?('false')
      if session[:temp_user_id].nil?
        user = TempUser.create
        p ("user_created with id: #{user.id}")
        session[:temp_user_id] = user.id

      else
        user = TempUser.find(session[:temp_user_id])
      end
    else
      user = current_user
    end

    if user.cart.nil?
      user.create_cart
      user.cart.is_active = true
      user.cart.total_m = 0
      user.cart.n_products = 0
      user.cart.save
      p user.cart
    end

    product_source = get_product(params['source_p'])
    size_id = params['size']

    price_product = AdminHelper.get_product_by_id(params['m_id'])['price']['data']['raw']['with_tax'].to_d
    price_logo = 0
    price_emblem = 0

    unless params['logo_id'].blank?
      logo = Picture.find(params['logo_id'])
      price_logo = logo.price
      if price_logo.nil?
        price_logo = 0
      end
    end

    unless params['emblem_id'].blank?
      emblem = Emblem.find(params['emblem_id'])
      price_emblem = emblem.emblem_cost
      if price_emblem.nil?
        price_emblem = 0
      end
    end

    total_m = price_logo + price_product + price_emblem

    product = CartProduct.create do |u|
      u.m_id = params['m_id']
      u.logo_id = params['logo_id']
      u.dim_x = HomeController.to_decimal(params['dim_x'])
      u.dim_y = HomeController.to_decimal(params['dim_y'])
      u.relation_x = HomeController.to_decimal(params['relation_x'])
      u.relation_y = HomeController.to_decimal(params['relation_y'])
      u.width = HomeController.to_decimal(params['width'])
      u.height = HomeController.to_decimal(params['height'])
      u.has_logo = !params['logo_id'].blank?
      u.has_emblem = false
      u.emblem_id = params['emblem_id']
      u.position_id = HomeController.to_integer(params['position'])
      u.size_id = size_id
    end

    user.cart.cart_products << product
    user.cart.n_products = user.cart.n_products + 1
    user.cart.save!


  end


  def delete_from_cart
    id = params['item_id']

    user = nil
    p current_user
    if user_signed_in?
      user = current_user
    else
      user = TempUser.find(session[:temp_user_id])
    end

    product = user.cart.cart_products.find(id)
    user.cart.n_products = user.cart.n_products - 1
    user.cart.total_m = user.cart.total_m - product.total_m - product.size_price
    user.cart.save!
    product.destroy
  end

  def cancel_order

    id_order = params[:id_order]
    id_product_cart = params[:id_product_cart]

    user = nil
    if user_signed_in?
      user = current_user
    else
      user = TempUser.find(session[:temp_user_id])
    end

    order_a = user.orders.find(id_order)
    refund(order_a, id_product_cart)
    unless order_a.state.eql?('shipped')
      cart_a = order_a.cart
      product = cart_a.cart_products.find(id_product_cart)
      cart_a.n_products = user.cart.n_products - 1
      cart_a.save!
      product.destroy
    end

    redirect_to '/account'

  end

  def self.to_decimal(n_text)
    if n_text.blank?
      return 0
    else
      return n_text.to_d
    end
  end

  def self.to_integer(n_text)
    if n_text.blank?
      return 0
    else
      return n_text.to_i
    end
  end

  def subscribe

    subscriber = Subscriber.new(email: params['email'])
    subscriber.save!

    redirect_to root_path
  end

end
