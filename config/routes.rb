Rails.application.routes.draw do

  devise_for :users, controllers: {
      registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
      sessions: 'admins/sessions'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  # get '/product/:id/:step' => 'home#product'
  get '/account' => 'home#account'
  get '/cancel_order' => 'home#cancel_order'

  post '/' => 'home#subscribe'

  get '/catalog' => 'home#catalog'
  get '/catalog/item/:id' => 'home#catalog_item'
  get '/catalog/items' => 'home#get_items'
  get '/catalog/product/images' => 'home#get_images_product'
  get '/catalog/product/sizes' => 'home#get_sizes_product'

  get '/checkout' => 'cart#new'
  post '/checkout' => 'cart#create'
  get '/mail_token' => 'cart#mail_token'

  get '/shopping_bag' => 'home#bag'

  # post '/product/:id/:step' => 'home#product'
  post '/add_cart' => 'home#add_to_cart'

  get '/admin/home' => 'admin#main'
  get '/admin/products' => 'admin#products'
  get '/admin/logos' => 'admin#logo'
  get '/admin/orders' => 'admin#orders'
  get '/admin/mailer' => 'admin#mailer'
  get '/admin/orders/:id_o' => 'admin#order_details'

  get '/admin/product/:id' => 'admin#info_product'
  get '/admin/product/edit/:id' => 'admin#edit_product'
  get '/admin/products/new' => 'admin#new_product'
  get '/admin/edit_variation/:source_product/:variation_id' => 'admin#modify_variation'
  get '/admin/add_variation/:source_product' => 'admin#add_variation'

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

  put '/product/edit' => 'product#save_product'
  put '/product/upload_image' => 'product#upload_image'
  put '/product/save_variation' => 'product#save_variation'

  delete '/product' => 'product#delete_product'

  put '/admin/product/edit/add/gallery/logo' => 'galleries#create'

  get '/temp_user_act' => 'home#temp_user_act'
  get '/temporary/user/orders' => 'home#temp_user_order'
  get '/temporary/user/menu' => 'home#temp_user_menu'

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

end
