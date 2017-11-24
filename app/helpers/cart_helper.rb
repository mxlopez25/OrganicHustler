module CartHelper
  include HomeHelper

  def refund(order, item = nil)
    if item.nil?
      Stripe::Refund.create(:charge => order.charge_id)
    else
      amount = product_price(item)[6]
      promo_code = get_cart.promotion_codes.first
      if promo_code
        amount = amount - (amount * (promo_code.rate / 100))
      end
      Stripe::Refund.create(:charge => order.charge_id, :amount => HomeController.to_integer(100 * amount))
    end
  end

end
