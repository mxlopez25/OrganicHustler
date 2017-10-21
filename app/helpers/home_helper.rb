
require 'rest_client'

module HomeHelper

  token = nil

  class << self
    attr_accessor :token
  end

  def self.generate_token
    moltin_client = Moltin::Api::Client
    if self.token.nil? || !moltin_client.authenticated?
      moltin_client.authenticate('client_credentials', client_id: 'RZsR5ErdxqMJNami9Bb7lOtDKy9ujFwaAb9bkCHm3s', client_secret: 'ffUhy8qZjb4vniRkHG9ZdoqEqIOpRBOGNqITVpbZpG')
    end
    self.token = moltin_client.access_token
    self.token
  end

  def get_user_toc
    user = current_user
    if user.nil?
      if session[:temp_user_id].nil?
        user = TempUser.create
        p ("user_created with id: #{user.id}")
        session[:temp_user_id] = user.id

      else
        user = TempUser.find(session[:temp_user_id])
      end
    end

    user
  end

  def get_products
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def get_image(id)
    begin
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/files/#{id}", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
    result = JSON.parse(response.body)['result']
    "https://#{result['segments']['domain']}fit/w600/h600/#{result['segments']['suffix']}"
    rescue
      p 'No image !################!'
    end

  end

  def get_regions(id)
    relations = RelationLogo.get_relation(id)
    if relations.nil?
      relations = RelationLogo.new(item_id: id, left_margin: 20, top_margin: 20, right_margin: 20, bottom_margin: 20)
      relations.save
    end
    relations
  end

  def self.get_product_by_id(id)
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/#{id}", {:Authorization => "Bearer #{self.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def get_showcase_items
    Product.all.order("id desc").limit 10
  end

  def create_temp_user
    user = TempUser.create
    p ("user_created with id: #{user.id}")
    session[:temp_user_id] = user.id

    user
  end

  def get_user
    user = current_user
    if user.nil?
      if session[:temp_user_id].nil?
        return create_temp_user
      else
        begin
          user = TempUser.find(session[:temp_user_id])
          return user
        rescue => e
          p e
          return create_temp_user
        end
      end
    end
    user
  end

  def get_cart_id

    user = get_user

    if user.cart.nil?
      user.create_cart
      user.cart.is_active = true
      user.cart.n_products = 0
      user.cart.save!
      p user.cart
      []
    else
      user.cart.id
    end

  end

  def get_cart
    user = current_user
    if user.nil?
      if session[:temp_user_id].nil?
        user = TempUser.create
        p ("user_created with id: #{user.id}")
        session[:temp_user_id] = user.id

      else
        user = TempUser.find(session[:temp_user_id])
      end
    end

    if user.cart.nil?
      user.create_cart
      user.cart.is_active = true
      user.cart.n_products = 0
      user.cart.save!
      user.cart
    else
      user.cart
    end
  end

  def get_item_count
    user = current_user
    if user.nil?
      if session[:temp_user_id].nil?
        user = TempUser.create
        p ("user_created with id: #{user.id}")
        session[:temp_user_id] = user.id

      else
        user = TempUser.find(session[:temp_user_id])
      end
    end
    
    if user.cart.nil?
      user.create_cart
      user.cart.is_active = true
      user.cart.n_products = 0
      user.cart.save!
      p user.cart
    end

    user.cart.n_products
  end

  def get_products_catalog(parameters)

    cat = params['view']

    products = Product.find_by_category cat

    JSON.parse(response.body)['result']
  end

  def product_price(p_cart_id)
    product = CartProduct.find(p_cart_id)
    product_main = Product.find(product.m_id)

    product_price = HomeController.to_decimal(product_main.price)
    base_product_tax = HomeController.to_decimal(product_main.taxes.amount)
    price_logo = 0
    price_emblem = 0

    unless product.logo_id.blank?
      logo = Logo.find(product.logo_id)
      price_logo = logo.price || 0
    end

    unless product.emblem_id.blank?
      emblem = PositionEmblemAdmin.find(product.emblem_id)
      price_emblem = emblem.price || 0
    end

    size_price = HomeController.to_decimal((Size.find product.size_id).price)

    total_m = (product_price + size_price + price_logo + price_emblem)
    real_product_tax = total_m * base_product_tax/product_price

    [product_price, real_product_tax, size_price, price_logo, price_emblem, total_m, (total_m + real_product_tax)]

  end

  def get_price(order_id = nil)
    
    if order_id.nil?
      total_price = 0
      get_cart.cart_products.each do |t|
        total_price += product_price(t.id).last
      end

      return total_price
    else
      total_price = 0
      Order.find(order_id).cart.cart_products.each do |t|
        total_price += product_price(t.id).last
      end

      return total_price
    end
  end


  def get_variation(pr, title, id)
    variation = nil
    pr['modifiers'].each do |modifier|
      if modifier[1]['title'].eql?(title)
        variation = modifier[1]['variations'][id]
      end
    end
    variation
  end

end
