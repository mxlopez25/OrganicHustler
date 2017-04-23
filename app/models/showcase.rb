class Showcase < ApplicationRecord
  has_one :video_show, dependent: :destroy
  has_one :image_show, dependent: :destroy
  belongs_to :group_showcase
end
