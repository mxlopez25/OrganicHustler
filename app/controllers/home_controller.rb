require 'json'
require 'rest_client'
class HomeController < ApplicationController
  include AdminHelper
  include CartHelper

  skip_before_filter :verify_authenticity_token
  before_action :authenticate_user!, only: 'account'

  def contact_us
  end

  def story
  end

  def index

    @config_products = ConfigurationWeb.where content_type: 1
    @cart_product_shared = params['cp']
    @shared_image = 'http://organichustler.com/images/logo'

  end

  def save_to_share
    product = CartProduct.create! do |u|
      u.product_id = params[:product][:product_id]
      u.size_id = 1
      u.color_id = params[:product][:color_id]
    end

    params[:product][:views].each do |index|

      custom_view = params[:product][:views][index]

      unless custom_view[:logo_id].blank?
        product.custom_logos << CustomLogo.create! do |cl|
          cl.product_image_id = custom_view[:picture_id]
          cl.color_id = custom_view[:color_id]
          cl.logo_id = custom_view[:logo_id]
          cl.x = custom_view[:x]
          cl.y = custom_view[:y]
          cl.multiplexer = custom_view[:multiplexer]
        end
      end

      unless custom_view[:position_emblem_id].blank?
        product.custom_emblems << CustomEmblem.create! do |ce|
          ce.product_image_id = custom_view[:picture_id]
          ce.color_id = custom_view[:color_id]
          ce.position_emblem_admin_id = custom_view[:position_emblem_id]
        end
      end
    end

    if product.custom_logos.length > 0
      product.has_logo = true
    else
      product.has_logo = false
    end

    if product.custom_emblems.length > 0
      product.has_emblem = true
    else
      product.has_emblem = false
    end

    product.save!
    render text: product.id, status: :ok
  end

  def colored_image
    pr_id = params['pr_id']
    mod = params['mod']
    actual_id = params['act_obj']

    variations_obj = {}

    response = RestClient.get("https://#{Moltin::Config.api_host}/v1/products/#{pr_id}/variations", {:Authorization => "Bearer #{HomeHelper.generate_token}"})
    result = JSON.parse(response.body)['result']
    result.each do |r|
      variations_obj[(r['modifiers'][mod]['var_id'])] = [r['id'].eql?(actual_id), "#{r['id']}"]
    end

    render json: variations_obj.to_json
  end

  def get_emblems_product
    emblems = []

    (Product.find params['product_id']).position_emblem_admins.where(color_id: params['color_id']).each do |emblem|
      emblem_js = JSON.parse(emblem.to_json)
      emblem_js[:url] = emblem.picture(:thumb)
      emblem_js[:sample] = emblem.product_image_id ? ProductImage.find(emblem.product_image_id).picture : nil
      emblems.push emblem_js
    end

    render json: emblems.to_json
  end

  def get_emblem

    hash_emblem = PositionEmblemAdmin.find params['emblem_id']
    emblem = JSON.parse hash_emblem.to_json
    emblem[:src] = hash_emblem.picture

    render json: emblem
  end

  def color_images
    pictures = Color.find(params[:color_id]).product_images.all
    pictures_array = []
    pictures.each do |picture|
      new_picture = JSON.parse picture.to_json
      new_picture[:src] = picture.picture
      pictures_array << new_picture
    end

    render json: pictures_array.to_json, code: 200
  end

  def get_items
    products_cat = Category.find_by_title params[:category]
    products_sty = Style.find_by_id params[:style]
    products_col = params[:color].blank? ? nil : params[:color]
    products_mat = Material.find_by_id params[:material]
    sql = "SELECT SQL_CALC_FOUND_ROWS DISTINCT products.* FROM products
          INNER JOIN categories_products ON products.id = categories_products.product_id
          #{products_sty ? 'INNER JOIN products_styles ON products.id = products_styles.product_id' : ''}
    #{products_col ? 'INNER JOIN colors ON products.id = colors.product_id' : ''}
    #{products_mat ? 'INNER JOIN materials_products ON products.id = materials_products.product_id' : ''}
          WHERE products.status = 1 #{products_cat ? 'AND category_id = '+ products_cat.id.to_s : params[:search].blank? ? '' : 'AND products.title LIKE \'%'+ (params[:search].to_s) +'%\'' } #{products_sty ? ' AND style_id = ' + products_sty.id.to_s : ''} #{products_col ? 'AND colors.title = \'' + products_col + '\'' : ''} #{products_mat ? ' AND material_id = ' + products_mat.id.to_s : ''} LIMIT #{12 * (params[:page].to_i - 1)}, 12"

    n_rows = 'SELECT FOUND_ROWS();'

    results = ActiveRecord::Base.connection.execute(sql)
    total = ActiveRecord::Base.connection.execute(n_rows).each(:as => :hash)[0]
    products = []
    results.each(:as => :hash) do |row|
      products << row.with_indifferent_access
    end

    render json: {ps: products, t: total}
  end

  def get_showcase_product
    id = GroupShowcase.where(screen: params[:screen], name_identity: params[:name_entity]).first.showcases.first.product_id
    render json: Product.find(id).to_json, code: 200
  end

  def get_styles_product
    render json: (Product.find params[:id]).styles.to_json
  end

  def get_materials_product
    render json: (Product.find params[:id]).materials.to_json
  end

  def get_images_product
    images = Product.get_all_images params['product_id']
    render json: images.to_json
  end

  def get_sizes_product
    sizes = Product.get_all_sizes params['product_id']
    render json: sizes.to_json
  end

  def get_presets_product
    presets = (Product.find params['product_id']).presets.where(showcase: true)
    render json: presets.to_json
  end

  def get_colors_product
    colors = (Product.find params['product_id']).colors
    render json: colors.to_json
  end

  def get_logos_product
    logos = (Product.find params['product_id']).logos
    render json: logos.to_json
  end

  def get_color_images_main
    picture = (Color.find params['color_id']).product_images.where(main: true).first
    render json: ({data: picture, picture: picture.picture}).to_json
  end

  def get_main_image
    render json: ({src: (Product.find params[:pr_id]).colors.where(preferred: true).first.product_images.where(main: true).first.picture, id: params[:pr_id]}).to_json
  end

  def get_preset_logo
    picture = (Logo.find params['logo_id']).picture
    render text: picture.to_s.html_safe
  end

  def catalog_item
    al = Product.find(params['id'])
    al.history_counts << HistoryCount.create!(owner: al)
    al.save!
    color = al.colors.where(preferred: true).first
    al.attributes.merge(main_color: color)
    render :json => JSON::parse(al.to_json).merge({main_color: color}).to_json
  end

  def catalog
    @parameters = params
  end

  def product
    @product = HomeHelper.get_product_by_id(params[:id])
    @parameters = params
  end

  def bag
  end

  def message_admin
    @ticket = Ticket.find_by(respond_token: params[:token], valid_token: true)
    if @ticket
      session[:ticket] = @ticket.id
      @ticket.valid_token = false
      @ticket.save!
    elsif session[:ticket]
      @ticket = Ticket.find session[:ticket]
    else
      tt = Ticket.find_by(respond_token: params[:token])
      p tt
      if tt
        TransactionalMailer.support_message(tt).deliver_now
      end
      redirect_to '/404.html'
    end
  end

  def message_user_add_new
    temp_user = TempUser.find_by_email(params['user-email'])
    unless temp_user
      temp_user = TempUser.create!
      temp_user.email = params['user-email']
    end
    subject = params['reason']

    t = Ticket.create! ({
        temp_user: temp_user,
        subject: subject,
        status: false
    })

    data = params['user-message']

    Message.create! ({
        ticket: t,
        data: data,
        client: true
    })

    TransactionalMailer.support_message(t).deliver_now
  end

  def message_user_add
    ticket_id = session[:ticket]
    data = params['data']
    client = params['client']
    t = Ticket.find(ticket_id)

    Message.create! ({
        ticket: t,
        data: data,
        client: client
    })
  end

  def bag_items

    products_partial = []
    CartProduct.where(cart_id: params['o_id'] || get_cart_id).each do |cp|
      ne_p = cp.as_json
      ne_p.merge!('qty' => 1)
      ne_p.merge!('consolidated' => false)
      products_partial << ne_p
    end

    products = products_partial

    (0..products_partial.length - 1).each {|i|

      pr = products_partial[i]

      unless pr['consolidated']
        products_partial.each do |dl|
          if dl['id'] != pr['id'] && pr['size_id'] == dl['size_id'] && pr['has_emblem'] == dl['has_emblem'] && pr['has_logo'] == false && dl['has_logo'] == false && pr['product_id'] == dl['product_id'] && pr['color_id'] == dl['color_id']
            tem_pr = CartProduct.find(pr['id'])
            tem_dl = CartProduct.find(pr['id'])

            if tem_pr.custom_emblems == tem_dl.custom_emblems
              dl['consolidated'] = true
              products[i]['qty'] = products[i]['qty'] + 1
            end
          end
        end
      end
    }

    cart_products = {
        tax_array: [],
        cost_array: [],
        products: [],
        order: params['order_id'] ? JSON.parse((Order.find params['order_id']).to_json) : {}
    }

    p cart_products[:order]

    products.each do |product|

      pr_price = product_price(product['id'])
      cart_products[:tax_array].push(pr_price[1])
      cart_products[:cost_array].push(pr_price[5])

      unless product['consolidated']

        product['data'] = get_product_l(product['product_id'])
        product['size'] = Size.find product['size_id']
        product['color'] = Color.find product['color_id']
        product['price_sgl'] = format('$%.2f', pr_price[5])
        product['status'] = product['state']
        cart_products[:products].push(product)
      end

    end

    c = params[:o_id] ? Cart.find(params[:o_id]) : get_cart
    cart_p = c.promotion_codes.first.try(:rate)
    cart_g = c.gifts.first.try(:rate)
    cart_products.merge!('discount' => (cart_p || cart_g || {rate: 0}))

    render json: cart_products.to_json, status: :ok
  end

  def temp_user_menu

  end

  def temp_user_order_details
    tuc = TempUserControl.where(ip_address: request.env['REMOTE_ADDR']).last
    if tuc
      @user = nil
      if tuc.t_available > Time.now && tuc.auth_token.eql?(session['temp_token'])
        @user = TempUser.find(tuc.temp_user_id)
        @order = @user.orders.find params[:order_id]
      end
    end
  end

  def temp_user_order

    if request.get?

      tuc = TempUserControl.where(ip_address: request.env['REMOTE_ADDR']).last
      if tuc
        @user = nil
        if tuc.t_available > Time.now && tuc.auth_token.eql?(session['temp_token'])
          @user = TempUser.find(tuc.temp_user_id)
        end
      end

    elsif request.post?
      begin
        temp_user_c = TempUserControl.where(auth_token: request.env['HTTP_AUTHORIZATION'], valid_token: 1).first
        if temp_user_c
          @user = TempUser.find(temp_user_c.temp_user_id)
          temp_user_c.ip_address = request.env['REMOTE_ADDR']
          temp_user_c.valid_token = false
          session['temp_token'] = request.env['HTTP_AUTHORIZATION']
          temp_user_c.save!
        end
      rescue => e
        p e
      end
    end
  end

  def send_verification

    user = TempUser.find_by_email(params['email'])

    mail = TUserTokenRequestMailer.new_token_request(user, request.host, request.port)
    mail.deliver_now
  end

  def invalidate
    TempUserControl.find_by_auth_token(session['temp_token']).delete
  end

  def orders
    user = TempUser.find TempUserControl.find_by_auth_token(session['temp_token']).temp_user_id

    orders = []
    user.orders.order(created_at: :desc).each do |o|
      ol = JSON.parse(o.to_json)
      ol.merge!(cart_id: o.cart.id)
      orders.push(ol)
    end
    render json: orders.to_json
  end

  def get_image_by_id
    render text: Picture.find(params[:id]).image.url(params[:style])
  end

  def get_logos_by_id

    logos = []
    Gallery.where(product_id: params['id']).first.pictures.all.each do |logo|
      logo_rt = {
          url: [logo.image.url(:large), logo.image.url(:thumb)],
          id: logo.id
      }
      logos.push(logo_rt)
    end

    render json: logos.to_json
  end

  def add_to_cart
    user = nil

    if session[:temp_user_id].nil?
      user = TempUser.create
      p ("user_created with id: #{user.id}")
      session[:temp_user_id] = user.id

    else
      user = TempUser.find(session[:temp_user_id])
    end

    if user.cart.nil?
      user.create_cart
      user.cart.is_active = true
      user.cart.total_m = 0
      user.cart.n_products = 0
      user.cart.save
      p user.cart
    end

    product = CartProduct.create! do |u|
      u.product_id = params[:product][:product_id]
      u.size_id = params[:product][:size_id]
      u.color_id = params[:product][:color_id]
    end

    params[:product][:views].each do |index|

      custom_view = params[:product][:views][index]

      unless custom_view[:logo_id].blank?
        product.custom_logos << CustomLogo.create! do |cl|
          cl.product_image_id = custom_view[:picture_id]
          cl.color_id = custom_view[:color_id]
          cl.logo_id = custom_view[:logo_id]
          cl.x = custom_view[:x]
          cl.y = custom_view[:y]
          cl.multiplexer = custom_view[:multiplexer]
        end
      end

      unless custom_view[:position_emblem_id].blank?
        product.custom_emblems << CustomEmblem.create! do |ce|
          ce.product_image_id = custom_view[:picture_id]
          ce.color_id = custom_view[:color_id]
          ce.position_emblem_admin_id = custom_view[:position_emblem_id]
        end
      end
    end

    if product.custom_logos.length > 0
      product.has_logo = true
    else
      product.has_logo = false
    end

    if product.custom_emblems.length > 0
      product.has_emblem = true
    else
      product.has_emblem = false
    end

    product.save!

    user.cart.cart_products << product
    user.cart.n_products = user.cart.n_products + 1
    user.cart.save!
  end

  def get_cart_item
    cart_product = CartProduct.find(params[:product_cart_id])
    size = Size.find(cart_product.size_id)
    color = Color.find(cart_product.color_id)
    product_image = color.product_images.where(main: 1).first

    al = Product.find(cart_product.product_id)
    color = al.colors.where(preferred: true).first
    al.attributes.merge(main_color: color)

    pictures_array = []
    color.product_images.each do |prff|
      n_prff = prff.as_json.merge!(url: prff.picture)
      pictures_array << n_prff
    end

    product = {
        id: cart_product.id,
        source_data: JSON::parse(al.to_json).merge({main_color: color}),
        size: {
            id: size.id,
            title: size.title,
            price: size.price
        },
        color: {
            id: color.id,
            title: color.title,
            price: color.price,
            code_hex: color.code_hex,
        },
        picture: product_image.picture,
        pictures: pictures_array,
        logos: [],
        emblems: [],
        has_logo: cart_product.has_logo,
        has_emblem: cart_product.has_emblem
    }

    cart_product.custom_logos.each do |cl|
      product[:logos] << {
          product_image_id: cl.product_image_id,
          color_id: cl.color_id,
          logo_id: cl.logo_id,
          logo_url: Logo.find(cl.logo_id).picture,
          x: cl.x,
          y: cl.y,
          multiplexer: cl.multiplexer
      }
    end

    cart_product.custom_emblems.each do |ce|
      product[:emblems] << {
          product_image_id: ce.product_image_id,
          color_id: ce.color_id,
          position_emblem_admin_id: ce.position_emblem_admin_id
      }
    end

    render json: product, code: 200
  end

  def get_cart_items

    obj = CartProduct.where(cart_id: get_cart.id)
    json_obj = JSON.parse(obj.to_json)
    json_obj.each {|json_data|
      json_data['product_data'] = Product.find(json_data['product_id'])
      json_data['emblem_url'] = Emblem.find_by(id: json_data['emblem_id']).try(:picture).try(:url)
      json_data['emblem_position_data'] = PositionEmblemAdmin.find_by(id: json_data['position_id'])
      json_data['logo_url'] = Picture.find_by(id: json_data['logo_id']).try(:image).try(:url)
      json_data['price'] = product_price(json_data['id'])
    }

    render json: json_obj
  end

  def product_price(p_cart_id)
    product = CartProduct.find(p_cart_id)
    product_main = Product.find(product.product_id)

    product_price = HomeController.to_decimal(product_main.price)
    base_product_tax = HomeController.to_decimal(product_main.taxes.amount)

    price_logos = 0
    price_emblems = 0

    product.custom_logos.each do |logos|
      price_logos += logos.logo.price || 0
    end

    product.custom_emblems.each do |emblem|
      price_emblems += emblem.position_emblem_admin.price || 0
    end

    size_price = HomeController.to_decimal((Size.find product.size_id).price)

    total_m = (product_price + size_price + price_logos + price_emblems)
    real_product_tax = total_m * base_product_tax


    [product_price, real_product_tax, size_price, price_logos, price_emblems, total_m, (total_m + real_product_tax)]
  end

  def clear_bag
    user = TempUser.find(session[:temp_user_id])
    cart = user.cart
    cart.cart_products.each do |cp|
      cp.unbind_cart
    end
  end

  def delete_from_cart
    id = params['item_id']
    user = TempUser.find(session[:temp_user_id])
    product = user.cart.cart_products.find(id)
    product.unbind_cart
  end

  def cancel_order
    user = TempUser.find TempUserControl.find_by_auth_token(session['temp_token']).temp_user_id
    order = user.orders.find params['id_order']
    product = order.cart.cart_products.find params['id_product_cart']
    product.state = 'Cancel requested'
    product.save!

    redirect_to '/temporary/user/orders'
  end

  def self.to_decimal(n_text)
    if n_text.blank?
      return 0
    else
      return n_text.to_d
    end
  end

  def self.to_integer(n_text)
    if n_text.blank?
      return 0
    else
      return n_text.to_i
    end
  end

  def subscribe
    subscriber = Subscriber.new(email: params['email'])
    TransactionalMailer.subscription_confirmation(subscriber).deliver_now
    if subscriber.save!
      redirect_to '?success=true#subscriber'
    else
      redirect_to '?success=false#subscriber'
    end
  end

  def confirm_email
    token = params[:token]
    subs = Subscriber.find_by_token(token)
    if subs
      subs.active = true
      subs.save!
      TransactionalMailer.subscribed(subs.email).deliver_now
    end

    redirect_to root_path
  end

  #SHOWCASES

  def showcase_mobile_products
    values = ConfigurationWeb.find_by_title('Showcase products').value.gsub /"/, ''
    y = values[1..-2].split(',').collect! {|n| n.to_s}

    products = []
    y.each do |p|
      products << Product.find(p)
    end

    render json: products.to_json, code: 200
  end


end
