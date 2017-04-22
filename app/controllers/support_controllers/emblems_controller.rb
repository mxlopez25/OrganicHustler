class SupportControllers::EmblemsController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!

  def add_emblems
    @product_id = params['id_p']
    render 'admin/products_functions/add_emblems'
  end

  def create
    p params[:file]['0']
    Emblem.create(
        picture: params[:file]['0'],
        emblem_cost: SupportControllers::EmblemsController.to_decimal(params['emblem_cost']),
        id_moltin: params['id_moltin'],

        pos_1_x: SupportControllers::EmblemsController.to_decimal(params['pos_1_x']),
        pos_1_y: SupportControllers::EmblemsController.to_decimal(params['pos_1_y']),
        pos_2_x: SupportControllers::EmblemsController.to_decimal(params['pos_2_x']),
        pos_2_y: SupportControllers::EmblemsController.to_decimal(params['pos_2_y']),
        pos_3_x: SupportControllers::EmblemsController.to_decimal(params['pos_3_x']),
        pos_3_y: SupportControllers::EmblemsController.to_decimal(params['pos_3_y']),
        pos_4_x: SupportControllers::EmblemsController.to_decimal(params['pos_4_x']),
        pos_4_y: SupportControllers::EmblemsController.to_decimal(params['pos_4_y']),

        rel_x: SupportControllers::EmblemsController.to_decimal(params['rel_x']),
        rel_y: SupportControllers::EmblemsController.to_decimal(params['rel_y']))
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