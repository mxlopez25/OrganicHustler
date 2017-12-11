class ShowcasesController < ApplicationController

  layout 'admin'
  before_action :authenticate_admin!
  skip_before_action :verify_authenticity_token, only: :create

  def create
    group = GroupShowcase.find(params['group_showcase_id'])
    if group.max_count == 1
      if group.showcases.first.blank?
        group.showcases.create! do |sh|
          sh.screen = params['screen']
          sh.active = params['active']
          unless params['video'].blank?
            sh.create_video_show(video: params['video'])
            sh.url_association = params['url_association']
          end
          unless params['image'].blank?
            sh.create_image_show(image: params['image'])
            sh.url_association = params['url_association']
          end
          unless params['product_id'].blank?
            sh.product_id = params['product_id']
            sh.url_association = "/product/#{params['product_id']}/1"
          end
        end
      else
        sh = group.showcases.first
        sh.screen = params['screen']
        sh.active = params['active']
        unless params['video'].blank?
          sh.create_video_show(video: params['video'])
          sh.url_association = params['url_association']
        end
        unless params['image'].blank?
          sh.create_image_show(image: params['image'])
          sh.url_association = params['url_association']
        end
        unless params['product_id'].blank?
          sh.product_id = params['product_id']
          sh.url_association = "/product/#{params['product_id']}/1"
        end
        sh.save!
      end
    else
      showcase = Showcase.create do |sh|
        sh.screen = params['screen']
        sh.active = params['active']
        unless params['video'].blank?
          p 'video##'
          sh.create_video_show(video: params['video'])
          sh.url_association = params['url_association']
        end
        unless params['image'].blank?
          p 'image##'
          sh.create_image_show(image: params['image'])
          sh.url_association = params['url_association']
        end
        unless params['product_id'].blank?
          p 'product##'
          sh.product_id = params['product_id']
          sh.url_association = "/product/#{params['product_id']}/1"
        end
      end
      group.showcases << showcase
      group.save!
    end
    redirect_to '/admin/home'
  end

end
