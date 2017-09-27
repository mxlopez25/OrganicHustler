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

  def get_emblems_product
    emblems = []

    (Product.find params['product_id']).position_emblem_admins.where(color_id: params['color_id']).each do |emblem|
      emblem_js = JSON.parse(emblem.to_json)
      emblem_js[:url] = emblem.picture(:thumb)
      emblems.push emblem_js
    end

    render json: emblems.to_json
  end

  def get_emblem

    hash_emblem = PositionEmblemAdmin.find params['emblem_id']
    emblem = JSON.parse hash_emblem.to_json
    emblem[:src] = hash_emblem.picture

    render json: emblem
  end

  def get_items
    products_cat = Category.find_by_title params[:category]
    products_sty = Style.find_by_id params[:style]
    products_col = params[:color].blank? ? nil : params[:color]
    products_mat = Material.find_by_id params[:material]
    sql = "SELECT products.* FROM products
          INNER JOIN categories_products ON products.id = categories_products.product_id
          #{products_sty ? 'INNER JOIN products_styles ON products.id = products_styles.product_id' : ''}
    #{products_col ? 'INNER JOIN colors ON products.id = colors.product_id' : ''}
    #{products_mat ? 'INNER JOIN materials_products ON products.id = materials_products.product_id' : ''}
          WHERE category_id = '#{products_cat.id}' #{products_sty ? ' AND style_id = ' + products_sty.id.to_s : ''} #{products_col ? 'AND colors.title = \'' + products_col + '\'' : ''} #{products_mat ? ' AND material_id = ' + products_mat.id.to_s : ''}"


    results = ActiveRecord::Base.connection.execute(sql)
    products = []
    results.each(:as => :hash) do |row|
      products << row.with_indifferent_access
    end

    render json: products.to_json
  end

  def get_styles_product
    render json: (Product.find params[:id]).styles.to_json
  end

  def get_materials_product
    render json: (Product.find params[:id]).materials.to_json
  end

  def get_images_product
    images = Product.get_all_images params['product_id']
    render json: images.to_json
  end

  def get_sizes_product
    sizes = Product.get_all_sizes params['product_id']
    render json: sizes.to_json
  end

  def get_presets_product
    presets = (Product.find params['product_id']).presets
    render json: presets.to_json
  end

  def get_colors_product
    colors = (Product.find params['product_id']).colors
    render json: colors.to_json
  end

  def get_logos_product
    logos = (Product.find params['product_id']).logos
    render json: logos.to_json
  end

  def get_color_images_main
    picture = (Color.find params['color_id']).product_images.where(main: true).first
    render json: ({data: picture, picture: picture.picture}).to_json
  end

  def get_preset_logo
    picture = (Logo.find params['logo_id']).picture
    render text: picture.to_s.html_safe
  end

  def catalog_item
    al = Product.find(params['id'])
    color = al.colors.where(preferred: true).first
    al.attributes.merge(main_color: color)
    render :json => JSON::parse(al.to_json).merge({main_color: color}).to_json
  end

  def catalog
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

      tuc = TempUserControl.where(ip_address: request.env['REMOTE_ADDR']).last
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
    unless user_signed_in?
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

    product = CartProduct.create do |u|

      u.m_id = params[:product][:product_id]
      u.size_id = params[:product][:size_id]
      u.color_id = params[:product][:color_id]

      u.has_logo = false
      unless params[:product][:logo_id].blank?
        u.logo_id = params[:product][:logo_id]
        u.dim_x = HomeController.to_decimal(params[:product][:logo_x])
        u.dim_y = HomeController.to_decimal(params[:product][:logo_y])
        u.relation_x = 500
        u.relation_y = 500
        u.multiplexer = HomeController.to_decimal(params[:product][:multiplexer])
        u.has_logo = true
      end

      u.has_emblem = false
      unless params[:product][:emblem].blank?
        u.emblem_id = params[:product][:emblem][:emblem_id]
        u.has_emblem = true
      end

    end

    user.cart.cart_products << product
    user.cart.n_products = user.cart.n_products + 1
    user.cart.save!
  end

  def get_cart_items

    obj = CartProduct.where(cart_id: get_cart_id)
    json_obj = JSON.parse(obj.to_json)
    json_obj.each {|json_data|
      json_data['product_data'] = Product.find(json_data['m_id'])
      json_data['emblem_url'] = Emblem.find_by(id: json_data['emblem_id']).try(:picture).try(:url)
      json_data['emblem_position_data'] = PositionEmblemAdmin.find_by(id: json_data['position_id'])
      json_data['logo_url'] = Picture.find_by(id: json_data['logo_id']).try(:image).try(:url)
      json_data['price'] = product_price(json_data['id'])
    }

    render json: json_obj
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
      product.state = 'Cancelled'
      product.save!
    end

    redirect_to '/temporary/user/orders'

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
