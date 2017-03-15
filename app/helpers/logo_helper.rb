
require 'rest_client'

module LogoHelper

  def self.get_galleries
    return Gallery.all
  end

end