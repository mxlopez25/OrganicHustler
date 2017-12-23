class ConfigurationWebsController < ApplicationController

  def update
    co = ConfigurationWeb.find(params[:id])
    co.value = params[:value]
    co. save!
  end

end
