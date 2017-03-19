class GalleriesController < ApplicationController

  def create
    unless params['id'].blank?
      @gallery = Gallery.find(params['id'])
      if @gallery.save
        if params[:file]
          @gallery.pictures.create(image: params[:file].tempfile, color: params[:color])
        end
      end
      return
    end

    unless params['name'].blank?
      @gallery = Gallery.new(name: params['name'])
      if @gallery.save
        if params[:file]
          @gallery.pictures.create(image: params[:file].tempfile, color: params[:color])
        end
      end
    end

  end

end