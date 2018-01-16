class CartProduct < ApplicationRecord
  belongs_to :cart, optional: true
  has_many :custom_logos
  has_many :custom_emblems

  has_attached_file :picture, styles: {medium: "500x500>", thumb: "300x300>"}, default_url: "/images/no-logo.jpg"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  def unbind_cart
    cart = self.cart
    cart.n_products = cart.n_products - 1
    cart.save!

    self.cart_id = ''
    self.save!
  end
end
