class PromotionCode < ApplicationRecord
  belongs_to :order, optional: true
  has_and_belongs_to_many :users
  has_and_belongs_to_many :carts

  def is_available?
    p this.created_at
  end

end
