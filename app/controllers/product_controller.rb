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

  def size_params(size_params)
    size_params.permit(:title, :price)
  end

  def logo_params(logo_params)
    logo_params.permit(:price, :picture)
  end

  def basic_product_params(pr_params)
    pr_params.permit(:title, :sku, :status, :price, :tax_band, :stock, :description)
  end

  def title_params(params_s)
    params_s.permit(:title)
  end

  def preset_params(preset_params)
    preset_params.permit(:x, :y, :multiplexer, :logo_id, :color_id)
  end

  def save_product
    (Product.find params[:id]).update (basic_product_params params[:attr])
    render :nothing => true, :status => 200
  end

  def add_size
    Product.find(params['pr_id']).sizes << Size.new(size_params (params['size']))
  end

  def add_logo
    Product.find(params['pr_id']).logos << Logo.new(logo_params (params))
  end

  def add_category
    Product.find(params['pr_id']).categories << Category.new(title_params (params))
  end

  def add_style
    Product.find(params['pr_id']).styles << Style.new(title_params (params))
  end

  def add_material
    Product.find(params['pr_id']).materials << Material.new(title_params (params))
  end

  def add_brand
    Product.find(params['pr_id']).brands << Brand.new(title_params (params))
  end

  def add_preset
    Product.find(params['pr_id']).presets << Preset.new(preset_params params)
  end

  def remove_size
    Size.find(params[:id]).destroy!
    render :json => {message: 'destroyed'}.to_json, :status => 200
  end

  def remove_logo
    Logo.find(params[:id]).destroy!
    render :json => {message: 'destroyed'}.to_json, :status => 200
  end

  def remove_category
    Product.find(params[:pr_id]).categories.delete Category.find(params[:id])
    render :json => {message: 'destroyed'}.to_json, :status => 200
  end

  def remove_style
    Product.find(params[:pr_id]).styles.delete Style.find(params[:id])
    render :json => {message: 'destroyed'}.to_json, :status => 200
  end

  def remove_material
    Product.find(params[:pr_id]).materials.delete Material.find(params[:id])
    render :json => {message: 'destroyed'}.to_json, :status => 200
  end

  def remove_brand
    Product.find(params[:pr_id]).brands.delete Brand.find(params[:id])
    render :json => {message: 'destroyed'}.to_json, :status => 200
  end

  def remove_preset
    Preset.find(params[:id]).destroy!
    render :json => {message: 'destroyed'}.to_json, :status => 200
  end

  def new_logo
    logo = Logo.create! price: params['price'], picture: params['file']
    render :json => logo.to_json, :status => 200
  end

  def new_color
    color = ApplicationRecord::Color.create! title: params['title'], price: params['price'], code_hex: params['color'], stock: params['stock'], preferred: params['preferred'], main_picture: params['main_picture']
    render :json => color.to_json, :status => 200
  end

  def new_image

    file = re_center_upload(params['file'])

    p (params['file'].original_filename.eql?(params['main_name']))
    image = ProductImage.create! color: ApplicationRecord::Color.find(params['parent_id']), picture: file, main: (params['file'].original_filename.eql?(params['main_name']))

    file.close
    file.unlink

    render :json => image.to_json, :status => 200
  end

  def new_product
    product = Product.new
    product.title = params['title']
    product.price = params['price']
    product.status = params['status']
    product.stock = params['stock']
    product.sku = params['sku']
    product.description = params['description']

    if params['sizes']
      params['sizes'].each do |size|
        product.sizes << Size.new(size_params (params['sizes'][size]))
      end
    end

    if params['logos']
      product.logos << Logo.find(params['logos'])
    end

    if params['colors']
      product.colors << ApplicationRecord::Color.find(params['colors'])
      #assigning main image
      image = product.colors[0].product_images[0]
      product.product_image_id = image.picture
    end

    if params['categories']
      params['categories'].each do |category|
        product.categories << Category.find_or_create_by!(title: params['categories'][category]['title'])
      end
    end

    if params['styles']
      params['styles'].each do |style|
        product.styles << Style.find_or_create_by!(title: params['styles'][style]['title'])
      end
    end

    if params['materials']
      params['materials'].each do |material|
        product.materials << Material.find_or_create_by!(title: params['materials'][material]['title'])
      end
    end

    if params['brands']
      params['brands'].each do |brand|
        product.brands << Brand.find_or_create_by!(title: params['brands'][brand]['title'])
      end
    end

    product.tax_band_id = params['tax_band']
    product.moltin_id = '000000000'
    product.save!

    product.colors.each do |color|
      if color.preferred
        image = color.product_images.find_by(main: true)
        product.product_image_id = image.picture
        product.save!
      end
    end


    render :json => product.to_json, :status => 200
  end

  def upload_image
    image = Magick::Image::from_blob(params['file'].read).first
    square_p = 300

    image.resize_to_fit!(square_p, square_p)
    new_img = Magick::Image.new(square_p, square_p)
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

  def re_center_upload(file)
    image = Magick::Image::from_blob(file.read).first
    square_p = 300

    image.resize_to_fit!(square_p, square_p)
    new_img = ::Magick::Image.new(square_p, square_p)
    filled = new_img.matte_floodfill(1, 1)
    filled.composite!(image, Magick::CenterGravity, ::Magick::OverCompositeOp)
    file = Tempfile.new(['rmagicFile', '.png'])
    p file.path
    filled.write(file.path)

    file
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
    (Product.find(params['pro_id'])).destroy!
  end

end
