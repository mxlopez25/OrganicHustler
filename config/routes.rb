Rails.application.routes.draw do

  devise_for :users, controllers: {
      registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
      sessions: 'admins/sessions'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  get '/product/:id/:step' => 'home#product'
  get '/account' => 'home#account'
  get '/cancel_order' => 'home#cancel_order'

  post '/' => 'home#subscribe'

  get '/catalog' => 'home#catalog'
  get '/catalog/item/:id' => 'home#catalog_item'
  get '/catalog/get_image' => 'home#get_image_by_id'
  get '/catalog/logos/:id' => 'home#get_logos_by_id'

  get '/checkout' => 'cart#new'
  post '/checkout' => 'cart#create'

  post '/product/:id/:step' => 'home#product'
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
  put '/admin/edit_variation/:id_pro/upload_m_image' => 'customs#upload_m_image'

  get '/customs/load_images/logo/:id' => 'customs#load_logo'
  get '/customs/load_info' => 'customs#product_info'
  get '/customs/edit_data' => 'customs#edit_product'
  get '/custom/delete_image_control' => 'customs#delete_image'
  get '/custom/load_logo_w_color' => 'customs#load_logo_w_color'

  post '/customs/reload_table' => 'customs#table_products'
  post '/customs/new/product' => 'customs#new_product'

  put '/customs/edit/product' => 'customs#save_product'
  put '/customs/upload_image' => 'customs#upload_image'
  put '/customs/save_variation' => 'customs#save_variation'

  put '/admin/product/edit/add/gallery/logo' => 'galleries#create'

  get '/temp_user_act' => 'home#temp_user_act'
  get '/temporary/user/orders' => 'home#temp_user_order'
  get '/temporary/user/menu' => 'home#temp_user_menu'

  delete '/temporary/user/re_send' => 'home#send_verification'

  post '/temporary/user/orders' => 'home#temp_user_order'

  namespace :support_controllers do
    get 'add/emblems/:id_p' => 'emblems#add_emblems'
    put 'add/emblems' => 'emblems#create'
  end

  resource :showcases
  resource :user_addresses
  resource :orders

end
