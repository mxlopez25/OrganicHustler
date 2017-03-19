
require 'rest_client'

module LogoHelper

  def self.get_galleries
    return Gallery.all
  end

  def get_colors(id)
    Gallery.get_colors(id)
  end

end