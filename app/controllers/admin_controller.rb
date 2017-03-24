class AdminController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!

  def main
    @state = 'products'
  end

  def products
    render :layout => false
    @state = 'products'

    Paperclip
  end

  def logo
    render :layout => false
    @state = 'logo'
  end

  def orders
    render :layout => false
    @state = 'orders'
  end

end
