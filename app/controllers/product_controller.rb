require 'rest_client'
require 'RMagick'
require 'tempfile'
require 'json'

class ProductController < ApplicationController
  include Magick
  layout 'customs_bl'

  skip_before_action :verify_authenticity_token

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

    @products = AdminHelper.get_product(look_up_text)

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

  def size_params(size_params)
    size_params.permit(:title, :price)
  end

  def logo_params(logo_params)
    logo_params.permit(:price, :image_url)
  end

  def new_logo
    logo = Logo.create! price: params['price'], picture: params['file']
    render :json => logo.to_json, :status => 200
  end

  def new_color
    color = ApplicationRecord::Color.create! title: params['title'], price: params['price'], code_hex: params['color'], stock: params['stock'], preferred: params['preferred']
    render :json => color.to_json, :status => 200
  end

  def new_image
    image = ProductImage.create! color: ApplicationRecord::Color.find(params['parent_id']), picture: params['file']
    render :json => image.to_json, :status => 200
  end

  def new_product
    product = Product.new
    product.title = params['title']
    product.price = params['price']
    product.status = params['status']
    product.stock = params['stock_level']
    product.sku = params['sku']
    product.description = params['description']

    params['sizes'].each do |size|
      product.sizes << Size.new(size_params (params['sizes'][size]))
    end

    product.logos << Logo.find(params['logos'])
    product.colors << ApplicationRecord::Color.find(params['colors'])

    params['categories'].each do |category|
      product.categories << Category.find_or_create_by!(title: params['categories'][category]['title'])
    end

    params['styles'].each do |style|
      product.styles << Style.find_or_create_by!(title: params['styles'][style]['title'])
    end

    params['materials'].each do |material|
      product.materials << Material.find_or_create_by!(title: params['materials'][material]['title'])
    end

    params['brands'].each do |brand|
      product.brands << Brand.find_or_create_by!(title: params['brands'][brand]['title'])
    end

    product.tax_band = TaxBand.find(params['tax_band_id'])
    product.moltin_id = '000000000'
    product.save!

    render :json => product.to_json, :status => 200
  end

  def upload_image
    image = Magick::Image::from_blob(params['file'].read).first
    square_p = 300

    image.resize_to_fit!(square_p, square_p)
    new_img = ::Magick::Image.new(square_p, square_p)
    filled = new_img.matte_floodfill(1, 1)
    filled.composite!(image, Magick::CenterGravity, ::Magick::OverCompositeOp)
    file = Tempfile.new(['rmagicFile', '.png'])
    p file.path
    filled.write(file.path)

    AdminHelper.set_image(file.path, params['id'])

    file.close
    file.unlink

    render :nothing => true, :status => 200
  end

  def re_center_upload(dir, id)
    image = Magick::Image::from_blob(dir.read).first
    square_p = 300

    image.resize_to_fit!(square_p, square_p)
    new_img = ::Magick::Image.new(square_p, square_p)
    filled = new_img.matte_floodfill(1, 1)
    filled.composite!(image, Magick::CenterGravity, ::Magick::OverCompositeOp)
    file = Tempfile.new(['rmagicFile', '.png'])
    p file.path
    filled.write(file.path)

    AdminHelper.set_image(file.path, id)

    file.close
    file.unlink

  end

  def upload_m_image
    p params['products'].split(',').map(&:to_i)
    params['products'].split(',').map(&:to_i).each {|product_var| re_center_upload(params['file'], product_var)}
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

  def delete_product
    AdminHelper.delete_product(params['pro_id'])
  end

end
