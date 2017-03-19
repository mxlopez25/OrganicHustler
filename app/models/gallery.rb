class Gallery < ApplicationRecord
  has_many :pictures, :dependent => :destroy

  def self.get_colors(id)

    colors = []

    Gallery.first.pictures.all.each do |picture|
      if !colors.include?(picture.color) && !picture.color.nil?
        colors.push(picture.color)
      end
    end

    return colors
  end

end
