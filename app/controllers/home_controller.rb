require 'json'
include AdminHelper
class HomeController < ApplicationController

  @open_quick_m = false
  def index

  end

  def catalog_item
    al = HomeHelper.get_product_by_id(params['id']).as_json
    al['variation_pp'] = false
    al['source_p'] = params['id']
    @open_quick_m = false
    if params['variation_ma'].eql?('false')
      @open_quick_m = true
      al['variation_pp'] = true
      al['source_p'] = params['source_p']
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
      user.cart.save!
      p user.cart
    end

    product_source = get_product(params['source_p'])

    variations = []
    product_source['modifiers'].each do |modifiers|
      variations.push(modifiers)
    end

    size_price = 0
    size_letter = ''
    variations[1][1]['variations'].each do |var|
      if var[1]['id'].eql? params['size']
        size_price = HomeController.to_decimal(var[1]['mod_price'][1..-1])
        size_letter = var[1]['title']
      end
    end

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
      u.total_m = total_m
      u.has_logo = !params['logo_id'].blank?
      u.has_emblem = false
      u.emblem_id = params['emblem_id']
      u.position_id = HomeController.to_integer(params['position'])
      u.size_leter = size_letter
      u.size_price = size_price
    end

    user.cart.cart_products << product
    user.cart.n_products = user.cart.n_products + 1
    user.cart.total_m = user.cart.total_m + total_m + size_price
    user.cart.save!


  end


  def delete_from_cart
    id = params['item_id']

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

    product = user.cart.cart_products.find(id)
    user.cart.n_products = user.cart.n_products - 1
    user.cart.total_m = user.cart.total_m - product.total_m - product.size_price
    user.cart.save!
    product.destroy
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
