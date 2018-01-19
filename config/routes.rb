Rails.application.routes.draw do

  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
  }
  devise_for :admins, controllers: {
      sessions: 'admins/sessions'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
  get '/home/showcase/product' => 'home#get_showcase_product'
  post '/share' => 'home#save_to_share'

  get '/account' => 'home#account'
  get '/contact_us' => 'home#contact_us'
  get '/story' => 'home#story'
  get '/bag_items' => 'home#bag_items'
  get '/cancel_order' => 'home#cancel_order'
  get '/confirm_email' => 'product#confirm_email'

  post '/' => 'home#subscribe'

  get '/showcase/mobile/products' => 'home#showcase_mobile_products'

  get '/catalog' => 'home#catalog'
  get '/cart' => 'home#get_cart_items'
  get '/catalog/item/:id' => 'home#catalog_item'
  get '/catalog/items' => 'home#get_items'
  get '/catalog/product/images' => 'home#get_images_product'
  get '/catalog/product/sizes' => 'home#get_sizes_product'
  get '/catalog/product/presets' => 'home#get_presets_product'
  get '/catalog/product/colors' => 'home#get_colors_product'
  get '/catalog/product/styles' => 'home#get_styles_product'
  get '/catalog/product/materials' => 'home#get_materials_product'
  get '/catalog/product/logos' => 'home#get_logos_product'
  get '/catalog/product/emblems' => 'home#get_emblems_product'

  get '/catalog/product/color/main_image' => 'home#get_color_images_main'
  get '/catalog/product/main_image' => 'home#get_main_image'
  get '/catalog/product/logo' => 'home#get_preset_logo'
  get '/catalog/product/emblem' => 'home#get_emblem'
  get '/catalog/product/color/images' => 'home#color_images'

  get '/checkout' => 'cart#new'
  post '/checkout' => 'cart#create'
  get '/mail_token' => 'cart#mail_token'

  patch '/cart/promo-code' => 'cart#add_promo_code'
  patch '/cart/gift-code' => 'cart#add_gift_code'
  patch '/change_order_email' => 'cart#change_order_manager'

  delete '/cart/promo-code' => 'cart#remove_promo_code'
  delete '/cart/gift-code' => 'cart#remove_gift_code'

  get '/shopping_bag' => 'home#bag'

  get '/get_cart_item' => 'home#get_cart_item'
  post '/add_cart' => 'home#add_to_cart'
  delete '/remove_from_cart' => 'home#delete_from_cart'

  get '/admin/home' => 'admin#main'
  get '/admin/products' => 'admin#products'
  get '/admin/logos' => 'admin#logo'
  get '/admin/orders' => 'admin#orders'
  get '/admin/mailer' => 'admin#mailer'
  get '/admin/orders/:id_o' => 'admin#order_details'
  get '/admin/support/ticket/:id' => 'admin#ticket_details'
  get '/admin/support/:email' => 'admin#support_user'
  get '/admin/promos' => 'admin#promo_code'
  get '/admin/taxes' => 'admin#tax_band'
  get '/admin/categories' => 'admin#category'
  get '/admin/gifts' => 'admin#gifts'
  get '/admin/support' => 'admin#support'

  get '/admin/all_products' => 'admin#get_products'
  get '/admin/all_categories' => 'admin#get_categories'

  get '/admin/product/:id' => 'admin#info_product'
  get '/admin/product/edit/:id' => 'admin#edit_product'
  get '/admin/products/new' => 'admin#new_product'
  get '/admin/edit_variation/:source_product/:variation_id' => 'admin#modify_variation'
  get '/admin/add_variation/:source_product' => 'admin#add_variation'

  get '/admin/products/color_images' => 'admin#get_images_colors'
  get '/admin/products/logos' => 'admin#get_logos'

  patch '/admin/products/change_main_picture' => 'admin#change_main_picture'
  patch '/admin/products/change_main_color' => 'admin#change_main_color'

  delete '/admin/product/photo' => 'admin#delete_picture'
  delete '/admin/product/color' => 'admin#remove_color'

  patch '/admin/products/change_main_picture' => 'admin#change_main_picture'
  delete '/admin/product/photo' => 'admin#delete_picture'

  post '/admin/add_variation/:source_product' => 'admin#add_variation'
  post '/admin/product/new' => 'admin#new_product'
  post '/admin/mailer' => 'admin#mailer_send'
  post '/admin/orders' => 'admin#order_search'
  post '/admin/orders/tag' => 'orders#get_tag'

  put '/admin/products' => 'admin#products'
  put '/admin/edit_variation/:id_pro/upload_m_image' => 'product#upload_m_image'

  get '/product/load_images/logo/:id' => 'product#load_logo'
  get '/product/load_info' => 'product#product_info'
  get '/product/edit_data' => 'product#edit_product'
  get '/custom/delete_image_control' => 'product#delete_image'
  get '/custom/load_logo_w_color' => 'product#load_logo_w_color'

  post '/product/reload_table' => 'product#table_products'
  post '/product/new/product' => 'product#new_product'
  post '/product/new/logo' => 'product#new_logo'
  post '/product/new/color' => 'product#new_color'
  post '/product/new/image' => 'product#new_image'

  post '/product/remove/size' => 'product#remove_size'
  post '/product/add/size' => 'product#add_size'

  post '/product/remove/logo' => 'product#remove_logo'
  post '/product/add/logo' => 'product#add_logo'

  post '/product/remove/category' => 'product#remove_category'
  post '/product/add/category' => 'product#add_category'

  post '/product/remove/style' => 'product#remove_style'
  post '/product/add/style' => 'product#add_style'

  post '/product/remove/material' => 'product#remove_material'
  post '/product/add/material' => 'product#add_material'

  post '/product/remove/brand' => 'product#remove_brand'
  post '/product/add/brand' => 'product#add_brand'

  post '/product/add/preset' => 'product#add_preset'
  post '/product/remove/preset' => 'product#remove_preset'

  post '/product/add/emblem' => 'product#add_emblem'
  post '/product/remove/emblem' => 'product#remove_emblem'

  put '/product/edit' => 'product#save_product'
  put '/product/upload_image' => 'product#upload_image'
  put '/product/save_variation' => 'product#save_variation'

  delete '/product' => 'product#delete_product'

  put '/admin/product/edit/add/gallery/logo' => 'galleries#create'

  get '/temp_user_act' => 'home#temp_user_act'
  get '/temporary/user/orders' => 'home#temp_user_order'
  get '/temporary/user/menu' => 'home#temp_user_menu'
  get '/orders' => 'home#orders'

  delete '/orders/shipment' => 'orders#cancel_shipment'
  patch '/orders/complete' => 'orders#complete'

  delete '/invalidate' => 'home#invalidate'


  delete '/temporary/user/re_send' => 'home#send_verification'

  post '/temporary/user/orders' => 'home#temp_user_order'

  namespace :support_controllers do
    get 'add/emblems/:id_p' => 'emblems#add_emblems'
    get 'emblems_created' => 'emblems#get_emblems_created'
    put 'add/emblems' => 'emblems#create'
    put 'add/emblems_position' => 'emblems#add_positions'
  end

  resource :showcases
  resource :user_addresses
  resource :orders
  resource :promotion_codes
  resource :gifts
  resource :tax_bands
  resource :categories
  resource :configuration_webs

end
