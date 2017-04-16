class HomeController < ApplicationController

  def index

  end

  def product
    @product = HomeHelper.get_product_by_id(params[:id])
    @parameters = params
  end

  def add_to_cart
    if params['user_signed'].eql?('false')
      user = nil
      if session[:temp_user_id].nil?
        user = TempUser.create
        p ("user_created with id: #{user.id}")
        session[:temp_user_id] = user.id

        user.create_cart
        user.cart.is_active = true
        user.cart.total_m = 0
        user.cart.n_products = 0
        p user.cart

      else
        user = TempUser.find(session[:temp_user_id])
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
        emblem = Picture.find(params['emblem_id'])
        price_logo = logo.price
        if price_logo.nil?
          price_logo = 0
        end
      end

      total_m = price_logo + price_product

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
        u.has_emblem = false #Missing emblem.rb model
        u.emblem_id = params['emblem_id']
        u.position_e_x = HomeController.to_decimal(params['emblem_x'])
        u.position_e_y = HomeController.to_decimal(params['emblem_y'])
        u.size_letter = '' #Add logic missing
        #Missing some attributes see migrations
      end

      user.cart.cart_products << product
      user.cart.n_products = user.cart.n_products + 1
      user.cart.total_m = user.cart.total_m + total_m

      p user.cart.cart_products.all

    end
  end

  def self.to_decimal(n_text)
    if n_text.blank?
      return 0
    else
      return n_text.to_d
    end
  end

end
