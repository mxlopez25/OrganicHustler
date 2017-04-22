class GalleriesController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!

  def create
    @gallery = Gallery.find_by_product_id(params['id'])
    p @gallery
    if params[:file]
      @gallery.pictures.create(image: params[:file].tempfile, color: params[:color])
    end
    @gallery.save
  end

end