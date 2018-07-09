
require 'ffmpeg'
require 'cocaine'

# Modifies CWC
class ConfigurationWebsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def update
    co = ConfigurationWeb.find(params[:id] ||  params[:configuration_web][:id])
    if params[:value]
      co.value = params[:value]
    end

    if params[:configuration_web]
      co.picture = params[:configuration_web][:picture]
      co.video = params[:configuration_web][:video]
    end

    co.save!
    redirect_to '/admin/home'
  end

end
