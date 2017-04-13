class Picture < ApplicationRecord

  belongs_to :gallery

  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100", large: "600x600"}

  do_not_validate_attachment_file_type :image

  def self.get_id_url(id, size)
    Picture.find(id).image.url(size)
  end

end
