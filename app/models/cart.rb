class Cart < ApplicationRecord
  has_many :cart_products, dependent: :destroy
  belongs_to :temp_user, :class_name => 'TempUser', :foreign_key => 'temp_user_id'
end
