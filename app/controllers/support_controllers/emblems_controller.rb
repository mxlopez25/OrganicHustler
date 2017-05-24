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
    v = (params['positions_add'].to_json.eql? 'null') ? ('[]') : (params['positions_add'].to_json)
    position_add = JSON.parse(v)
    v = (params['positions_rev'].to_json.eql? 'null') ? ('[]') : (params['positions_rev'].to_json)
    position_rev = JSON.parse(v)

    position_add.each do |pos|
      unless pos.blank?
        if pos[1]['position_id'].eql? '-1'
          PositionEmblemAdmin.create(emblem_position_params(pos[0]))
        else
          begin
            position = PositionEmblemAdmin.find(pos[1]['position_id'])
            position.try(:update_attributes, emblem_position_params(pos[0]))
          rescue => e
            p e
          end
        end
      end
    end

    position_rev.each do |pos|
      unless pos.blank?
        begin
          PositionEmblemAdmin.destroy(pos[1]['position_id'])
        rescue => e
          p e
        end
      end
    end
  end

  def emblem_position_params(id)
    params.require(:positions_add)[id].permit(:name, :x, :y, :rel_x, :rel_y, :emblem_id, :cost, :width, :height)
  end

  def get_emblems_created

    positions = []

    Emblem.where(:id_moltin => params['product_id']).each do |emblem|
      emblem.position_emblem_admins.each do |position|
        js_position = JSON.parse(position.to_json)
        js_position[:url] = emblem.picture.url
        positions.push js_position
      end
    end

    render json: positions.to_json
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