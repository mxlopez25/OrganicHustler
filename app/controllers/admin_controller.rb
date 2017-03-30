class AdminController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!

  def main
  end

  def products
  end

  def logo
  end

  def orders
  end

  def info_product
    @product = AdminHelper.get_product_by_id(params[:id])
    render 'admin/products_functions/info_product'
  end

  def edit_product
    @product = AdminHelper.get_product_by_id(params[:id])
    render 'admin/products_functions/edit_product'
  end

end
