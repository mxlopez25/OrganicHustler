class SupportControllers::EmblemsController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!

  def add_emblems
    @product_id = params['id_p']
    render 'admin/products_functions/add_emblems'
  end

  def create
    emblem = Emblem.create(
        picture: params[:file]['0'],
        id_moltin: params['id_moltin']
    )

    json_emblem = JSON.parse(emblem.to_json)
    json_emblem[:url] = emblem.picture.url

    render json: json_emblem.to_json.html_safe
  end

  def add_positions

    position_add = JSON.parse(params['positions_add'].to_json)
    v = (params['positions_rev'].to_json.eql? 'null') ? ('[]') : (params['positions_rev'].to_json)
    p v
    position_rev = JSON.parse(v)

    position_add.each do |pos|
      unless position_rev.include? pos
        a = PositionEmblemAdmin.create!(emblem_position_params)
      end
    end

    render nothing: true
  end

  def emblem_position_params
    params.require(:positions_add)['0'].permit(:x, :y, :rel_x, :rel_y, :emblem_id, :cost, :width, :height)
  end

  def self.to_decimal(n_text)
    if n_text.blank?
      return 0
    else
      return n_text.to_d
    end
  end

  def self.to_integer(n_text)
    if n_text.blank?
      return 0
    else
      return n_text.to_i
    end
  end

end