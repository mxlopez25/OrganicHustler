class HomeController < ApplicationController

  def index

  end

  def product
    @product = HomeHelper.get_product_by_id(params[:id])
    @parameters = params
  end

  def add_to_cart
    if params['user_signed'].eql?('false')
      user
    end
  end

end
