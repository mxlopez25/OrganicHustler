require 'rest_client'

module ApplicationHelper

  def self.product_price(p_cart_id)
    product = CartProduct.find(p_cart_id)
    product_main = Product.find(product.product_id)

    product_price = HomeController.to_decimal(product_main.price)
    base_product_tax = HomeController.to_decimal(product_main.taxes.amount)

    price_logos = 0
    price_emblems = 0

    product.custom_logos.each do |logos|
      price_logos += logos.logo.price || 0
    end

    product.custom_emblems.each do |emblem|
      price_emblems += emblem.position_emblem_admin.price || 0
    end

    size_price = HomeController.to_decimal((Size.find product.size_id).price)

    total_m = (product_price + size_price + price_logos + price_emblems)
    real_product_tax = total_m * base_product_tax

    [product_price, real_product_tax, size_price, price_logos, price_emblems, total_m, (total_m + real_product_tax)]
  end

end
