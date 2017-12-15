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

    p_array = []
    products = Product.get_by_attributes(params[:id], params[:sku], params[:title], params[:amount], params[:category]).last(params['n'] || 40)
    for product in products
      pr = JSON.parse(product.to_json.to_s)
      pr.merge!(categories_l: Product.find(product[:id]).categories.map {|f| f.title}.join(', '))
      p_array.push pr
    end

    render json: p_array.to_json
  end

  def get_categories
    render json: Category.all, code: 200
  end

  def orders
  end

  def mailer
  end

  def promo_code
  end

  def tax_band

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

end
