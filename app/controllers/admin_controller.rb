require 'rest-client'
require 'easypost'
include HomeHelper

class AdminController < ApplicationController
  EasyPost.api_key = ENV['EASYPOST_SECRET']

  layout 'admin'
  layout 'customs_bl', :only => :preview_mail
  before_action :authenticate_admin!

  def main
  end

  def preview_mail
    if params[:id] == '1'
      @content = TransactionalMailer.shipped_out(Order.last).to_s.html_safe
    elsif params[:id] == '2'
      @content = TransactionalMailer.support_message(Ticket.last).to_s.html_safe
    elsif params[:id] == '3'
      @content = TransactionalMailer.subscription_confirmation(Subscriber.last).to_s.html_safe
    elsif params[:id] == '4'
      @content = TransactionalMailer.subscribed('oh@admin').to_s.html_safe
    elsif params[:id] == '5'
      @content = PurchaseMailer.new_purchase(Order.last).to_s.html_safe
    end
  end

  def support
  end

  def products
    @amount = params[:limit] || 40
  end

  def get_products

    p_array = []
    products = Product.get_by_attributes(params[:id], params[:sku], params[:title], params[:amount], params[:category], (params[:page] || 1))
    for product in products[0]
      pr = JSON.parse(product.to_json.to_s)
      pr.merge!(categories_l: Product.find(product[:id]).categories.map {|f| f.title}.join(', '))
      p_array.push pr
    end

    render json: {product: JSON.parse(p_array.to_json), total: products[1]}
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

  def category
  end

  def gifts
  end

  def stats
  end

  # Stats

  def get_product_visit
    visits = []
    start_time = Date.strptime(params['from_day'])
    end_time = Date.strptime(params['to_day'])
    product_id = params['id']
    (start_time..end_time).step(1) do |i|
      visits << [i, (HistoryCount.where 'owner_type = \'Product\' AND created_at >= :s_time AND created_at <= :e_time AND owner_id = :id',
                         s_time: i.beginning_of_day,
                         e_time: i.at_end_of_day,
                         id: product_id
      ).size]
    end
    render json: visits, status: :ok
  end

  def get_data_visits
    visits_days = []
    start_time = Date.strptime(params['from_day'])
    end_time = Date.strptime(params['to_day'])
    (start_time..end_time).step(1) do |i|
      day = TempUser.where('created_at >= :s_time AND created_at <= :e_time', s_time: (i.beginning_of_day), e_time: (i.at_end_of_day))
      visits_days.push([i, day.size])
    end
    render json: visits_days, status: :ok
  end

  def get_data_money
    orders_price = []
    start_time = Date.strptime(params['from_day'])
    end_time = Date.strptime(params['to_day'])

    (start_time..end_time).step(1) do |i|
      orders = Order.where('created_at >= :s_time AND created_at <= :e_time', s_time: (i.beginning_of_day), e_time: (i.at_end_of_day) )
      price = 0
      shipping = 0
      orders.each do |ord|
        mm = HomeHelper::get_price(ord.id)
        price = price + ((mm == -1) ? 0 : mm)
        if ord.tag_link
          shipping = shipping + EasyPost::Shipment.retrieve(ord.tag_link)["selected_rate"]["rate"].to_f
        end
      end
      orders_price.push([i, price.to_f, shipping])
    end
    render json: orders_price, status: :ok
  end

  def get_data_products_view
    products_view = []
    products_count = []
    products = Product.find((HistoryCount.where('owner_type = \'Product\' AND created_at >= :s_time AND created_at <= :e_time', s_time: params['from_day'], e_time: params['to_day'])).pluck(:owner_id))
    products.each do |pr|
      products_view.push(pr)
    end

    start_time = Date.strptime(params['from_day'])
    end_time = Date.strptime(params['to_day'])

    (start_time..end_time).step(1) do |i|
      day = [i]
      counts = HistoryCount.where('owner_type = \'Product\' AND created_at >= :s_time AND created_at <= :e_time', s_time: (i.beginning_of_day), e_time: (i.at_end_of_day))
      products.each do |p|
        day.push(counts.where(owner_id: p.id).size)
      end
      products_count.push(day)
    end

    render json: {pr: products_view, counts: products_count}, status: :ok
  end

  def get_data_orders

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

  def ticket_details
    id = params['id']
    @ticket = Ticket.find id
    render '/admin/support_functions/ticket_details.html.erb'
  end

  def support_user
    email = params['email']
    @temp_user = TempUser.find_by_email(email)
    render '/admin/support_functions/support_email.html.erb'
  end

  def mailer_send
    subject = params['subject']
    content = params['editor'].html_safe

    email_list = []

    Subscriber.where(active: 1).each do |user|
      email_list << user.email
    end

    SubscriptionMailer.new_promotion(email_list, subject, content).deliver_later

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
