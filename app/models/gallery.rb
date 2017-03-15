class Gallery < ApplicationRecord
  has_many :pictures, :dependent => :destroy

end
