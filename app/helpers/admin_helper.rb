
require 'rest_client'

module AdminHelper

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

  def self.get_products
    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products", {:Authorization => "Bearer #{self.generate_token}"})
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
        :slug => params['slug'].gsub(',',' ')
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
    response = RestClient.delete("https://api.molt.in/v1/files/#{image_id}", {:Authorization => "Bearer #{self.generate_token}"})
    response.body
  end



end
