require 'rest-client'

class AdminController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!

  def main
  end

  def products
    @amount = params[:limit] || 40
  end

  def get_products

=begin
    products_cat = Category.find_by_title params[:category]
    products_sty = Style.find_by_id params[:style]
    products_col = params[:color].blank? ? nil : params[:color]
    products_mat = Material.find_by_id params[:material]
    sql = "SELECT DISTINCT products.* FROM products
          INNER JOIN categories_products ON products.id = categories_products.product_id
          #{products_sty ? 'INNER JOIN products_styles ON products.id = products_styles.product_id' : ''}
    #{products_col ? 'INNER JOIN colors ON products.id = colors.product_id' : ''}
    #{products_mat ? 'INNER JOIN materials_products ON products.id = materials_products.product_id' : ''}
          WHERE #{products_cat ? ' category_id = '+ products_cat.id.to_s : params[:search].blank? ? '' : ' products.title LIKE \'%'+ (params[:search].to_s) +'%\'' } #{products_sty ? ' AND style_id = ' + products_sty.id.to_s : ''} #{products_col ? 'AND colors.title = \'' + products_col + '\'' : ''} #{products_mat ? ' AND material_id = ' + products_mat.id.to_s : ''}"

    p sql

    results = ActiveRecord::Base.connection.execute(sql)
    products = []
    results.each(:as => :hash) do |row|
      products << row.with_indifferent_access
    end

    render json: products.to_json
=end

    p_array = []
    products = Product.last(params['n'] || 40)
    for product in products
      pr = JSON.parse(product.to_json.to_s)
      pr.merge!(categories_l: product.categories.map {|f| f.title}.join(', '))
      p_array.push pr
    end

    render json: p_array.to_json
  end

  def get_categories
    render json: Category.all, code: 200
  end

  def logo
  end

  def orders
  end

  def mailer
  end

  def change_main_picture
    (Color.find params[:color_id]).change_main_photo(params[:photo_id])
  end

  def delete_picture
    color = Color.find params[:color_id]
    photos = color.product_images.where(picture_file_name: params[:file_name]).first
    change = false
    p photos.main
    if photos.main
      change = true;
    end

    photos.destroy!

    if change
      temp_col = color.product_images.all.first
      temp_col.main = true
      temp_col.save!
    end
  end

  def order_search
    id = params['search-field']
    render '/admin/orders'
  end

  def remove_color
    color = Color.find params[:color_id]

    presets = Preset.where(color_id: color.id)
    presets.each do |p|
      p.destroy!
    end

    emblem = PositionEmblemAdmin.where(color_id: color.id)
    emblem.each do |e|
      e.destroy!
    end

    preferred = color.preferred
    product = color.product
    color.destroy!

    if preferred
      n_color = product.colors.all.first
      if n_color
        n_color.preferred = true
        n_color.save!
      end
    end
  end

  def change_main_color
    (Product.find params['pr_id']).colors.each do |c|
      if c.id.to_s.eql? params['color']
        c.preferred = true
        c.save!
      else
        c.preferred = false
        c.save!
      end
    end
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
    @product = Product.find(params[:id])
    render 'admin/products_functions/info_product'
  end

  def edit_product
    @product = Product.find(params[:id])
    render 'admin/products_functions/edit_product'
  end

  def get_images_colors
    images = Product.get_all_images_colors params['product_id']
    render json: images.to_json
  end

  def get_logos
    render json: (Product.find params['product_id']).logos.to_json
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
