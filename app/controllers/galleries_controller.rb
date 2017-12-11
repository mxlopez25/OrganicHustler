class GalleriesController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!

  def create
    @gallery = Gallery.find_by_product_id(params['id'])
    p @gallery
    if params[:file]
      params[:file].each do |file|
        p file
        @gallery.pictures.create(image: params[:file][file].tempfile, color: params[:color])
        @gallery.save!
      end

    end
  end

end