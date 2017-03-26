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

end
