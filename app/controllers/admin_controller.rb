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
      #RestClient.post("https://#{Moltin::Config.api_host}/v1/products/#{@product_id}/modifiers/#{params['modifier']}/variations", {title: params['changes'], mod_price: params['sign'].to_s.concat(params['price_mod'])}, {:Authorization => "Bearer #{AdminHelper.generate_token}"})
      #@product = AdminHelper.get_product_by_id(@product_id)
      #render 'admin/products_functions/edit_product'
    end
  end


end
