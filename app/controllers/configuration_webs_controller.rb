class ConfigurationWebsController < ApplicationController

  def update
    co = ConfigurationWeb.find(params[:id] ||  params[:configuration_web][:id])
    if params[:value]
      co.value = params[:value]
    end

    if params[:configuration_web]
      co.picture = params[:configuration_web][:picture]
    end

    co.save!
    redirect_to '/admin/home'
  end

end
