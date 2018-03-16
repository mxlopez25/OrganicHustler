class Picture < ApplicationRecord

  belongs_to :gallery

  has_attached_file :image, styles: {medium: "500x500", thumb: "300x300", large: "800x800", s_thumb: "120x120"}

  do_not_validate_attachment_file_type :image

  def self.get_id_url(id, size)
    Picture.find(id).image.url(size)
  end

end
