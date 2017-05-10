class PromotionCode < ApplicationRecord
  belongs_to :order, optional: true

  def is_available?
    p this.created_at
  end

end
