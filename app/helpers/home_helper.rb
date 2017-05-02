
require 'rest_client'

module HomeHelper

  @token = nil

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

  def get_products
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def get_image(id)
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/files/#{id}", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
    result = JSON.parse(response.body)['result']
    "https://#{result['segments']['domain']}fit/w600/h600/#{result['segments']['suffix']}"
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

  def get_teaser(text)
    "#{text[0, 30]}"
  end

  def get_complete(text)
    "#{text[30..-1]}"
  end

  def get_showcase_items
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products?limit=5", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def get_cart_id
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
      user.cart.total_m = 0
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
      user.cart.total_m = 0
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
      user.cart.total_m = 0
      user.cart.n_products = 0
      user.cart.save!
      p user.cart
    end

    user.cart.n_products
  end

  def get_products_f_catalog(parameters)
    available_params = ''
    parameters.each do |t|
      unless params[t].blank?
        if t != 'looks' && t != 'hats' && t != 'men' && t != 'women' && t != 'brand' && t != 'controller' && t != 'action'
          available_params = "#{available_params}?#{t}=#{params[t]}"
        end
      end
    end

    p available_params

    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/search/#{available_params}", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def get_p_price(id, logo_id, emblem_id, size_price)
    pr = AdminHelper.get_product_by_id(id)

    price_product = pr['price']['data']['raw']['without_tax'].to_d
    tax = pr['price']['data']['raw']['tax'].to_d
    price_logo = 0
    price_emblem = 0

    unless logo_id.blank?
      logo = Picture.find(logo_id)
      price_logo = logo.price
      if price_logo.nil?
        price_logo = 0
      end
    end

    unless emblem_id.blank?
      emblem = Emblem.find(emblem_id)
      price_emblem = emblem.emblem_cost
      if price_emblem.nil?
        price_emblem = 0
      end
    end

    total_m = price_logo + price_product + price_emblem + size_price
    [total_m, tax]
  end

end
