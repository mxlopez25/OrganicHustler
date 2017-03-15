class HomeController < ApplicationController

  def index

  end

  def product
    @product = HomeHelper.get_product_by_id(params[:id])
  end

end
