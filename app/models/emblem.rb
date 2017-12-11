class Emblem < ApplicationRecord
  has_attached_file :picture, styles: {medium: "500x500>", thumb: "300x300>"}, default_url: "/images/no-logo.jpg"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  has_many :position_emblem_admins

end
