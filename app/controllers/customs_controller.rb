require 'rest_client'

class CustomsController < ApplicationController

  layout 'customs_bl'

  def table_products

    parameters = {}

    unless params['id'].blank?
      @products = [AdminHelper.get_product_by_id(params['id'])]
      return
    end

    unless params['sku'].blank?
      parameters['sku'] = "=#{params['sku']}"
    end

    unless params['title'].blank?
      parameters['slug'] = "='%#{params['title']}%'"
    end

    unless params['amount'].blank?
      parameters['sale_price'] = "<=#{params['amount']}"
    end

    unless params['category'].blank?
      parameters['category'] = "=#{params['category']}"
    end

    look_up_text = '?'
    parameters.each do |type, parameter|
      look_up_text.concat "#{type}#{parameter}&"
    end

    @products = AdminHelper.get_product(look_up_text);

  end

  def product_info
    id = params['id']
    @product = AdminHelper.get_product_by_id(id)
  end

  def edit_product
    id = params['id']
    @product = AdminHelper.get_product_by_id(id)
  end

  def save_product
    AdminHelper.edit_product(params)
    render :nothing => true, :status => 200
  end

  def new_product
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
        :slug => params['slug'].gsub(',', ' '),
        :requires_shipping => params['requires_shipping'],
        :catalog_only => params['catalog_only']
    }

    RestClient.post('https://api.molt.in/v1/products', fields, {:Authorization => "Bearer #{AdminHelper.generate_token}"})
    render :nothing => true, :status => 200
  end

  def upload_image
    AdminHelper.set_image(params['file'].tempfile, params['id'])
    render :nothing => true, :status => 200
  end

  def upload_m_image
    p params['products'].split(',').map(&:to_i)
    params['products'].split(',').map(&:to_i).each { |product_var| AdminHelper.set_image(params['file'].tempfile, product_var) }
    render :nothing => true, :status => 200
  end

  def delete_image
    AdminHelper.delete_image(params['pro_image_id'])
    @id_product = params['pro_id']
    @product_images = AdminHelper.get_product_by_id(params['pro_id'])['images']
  end

  def load_logo
    id = params['id']
    gallery = Gallery.find(id)
    @logos = gallery.pictures.all
  end

  def save_variation
    margin = RelationLogo.find_by_item_id(params['id'])

    if params['type'] == '0'
      margin.left_margin=params['variation']
    elsif params['type'] == '1'
      margin.top_margin=params['variation']
    elsif params['type'] == '2'
      margin.right_margin=params['variation']
    else
      margin.bottom_margin=params['variation']
    end
    margin.save
    render :nothing => true, :status => 200
  end

  def load_logo_w_color
    id = params['id']
    colors = params['color']

    @logos = []
    Gallery.find(id).pictures.all.each do |logo|
      if colors.include?(logo.color)
        @logos.push(logo)
      end
    end

  end

  def add_image_gallery

  end

end
