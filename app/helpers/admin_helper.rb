require 'rest_client'

module AdminHelper

  @token = nil

  class << self
    attr_accessor :token
  end

  def self.generate_token
    moltin_client = Moltin::Api::Client
    if self.token.nil? || !moltin_client.authenticated?
      moltin_client.authenticate('client_credentials', client_id: ENV['MOLTIN_USER'], client_secret: ENV['MOLTIN_PASS'])
    end
    self.token = moltin_client.access_token
    self.token
  end

  def self.get_categories
    response = RestClient.get("https://#{Moltin::Config::api_host}/v1/categories", {:Authorization => "Bearer #{self.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def self.get_brands
    response = RestClient.get("https://#{Moltin::Config::api_host}/v1/brands", {:Authorization => "Bearer #{self.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def self.get_taxes
    response = RestClient.get("https://#{Moltin::Config::api_host}/v1/taxes", {:Authorization => "Bearer #{self.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def self.get_products(offset)
    response = RestClient.get("https://api.molt.in/v1/products?limit=#{offset}&offset=0}", {:Authorization => "Bearer #{self.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def self.get_product(params)
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/search/#{params}", {:Authorization => "Bearer #{self.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def self.get_product_by_id(id)
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/#{id}", {:Authorization => "Bearer #{self.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def self.edit_product(params)
    fields = {
        :title => params['title'],
        :sku => params['sku'],
        :status => params['status'],
        :category => params['category'],
        :brand => params['brand'],
        :price => params['price'],
        :tax_band => params['tax_band'],
        :sale_price => params['sale_price'],
        :stock_level => params['stock_level'],
        :stock_status => params['stock_status'],
        :description => params['description'],
        :slug => params['slug'].gsub(',', ' ')
    }

    p fields
    p "https://api.molt.in/v1/products/#{params['id']}"

    response = RestClient.put("https://api.molt.in/v1/products/#{params['id']}", fields, {:Authorization => "Bearer #{self.generate_token}"})
    response.body
  end

  def self.set_image(dir, id)
    response = RestClient.post("https://api.molt.in/v1/files?assign_to=#{id}", {:file => File.new(dir)}, {:Authorization => "Bearer #{self.generate_token}", :assign_to => id})
    response.body
  end

  def self.delete_image(image_id)
    begin
      response = RestClient.delete("https://api.molt.in/v1/files/#{image_id}", {:Authorization => "Bearer #{self.generate_token}"})
      response.body
    rescue
      p 'no image !##############!'
    end
  end

  def self.delete_product(id)
    begin
      response = RestClient.delete("https://api.molt.in/v1/products/#{id}", {:Authorization => "Bearer #{self.generate_token}"})
      response.body
    rescue
      p 'no product !##############!'
    end
  end

  def get_gallery(id)
    Gallery.find_by_product_id(id)
  end

  def create_gallery(id)
    Gallery.new(product_id: id, name: 'product..set..i').save
  end

  def get_product(id)
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/#{id}", {:Authorization => "Bearer #{AdminHelper.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def get_product_l(id)
    Product.find id
  end

  def get_product_variations(id)
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/#{id}/variations", {:Authorization => "Bearer #{AdminHelper.generate_token}"})
    JSON.parse(response.body)['result']
  end

  def getJson(data)
    JSON.parse(data)
  end

  def get_thumb_g_id(id, size)
    if !id.blank?
      Picture.get_id_url(id, size)
    else
      ''
    end

  end

  def get_emblem_image(id)
    if !id.blank?
      Emblem.where(:id => id).first.try(:picture).try(:url)
    else
      ''
    end
  end

  def get_position_emblem(id)
    if !id.blank?
      PositionEmblemAdmin.where(:id => id).first.to_json.html_safe
    else
      ''
    end
  end


end
