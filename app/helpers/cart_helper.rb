module CartHelper
  include HomeHelper

  def refund(order, item = nil)
    if item.nil?
      Stripe::Refund.create(:charge => order.charge_id)
    else
      Stripe::Refund.create(:charge => order.charge_id, :amount => HomeController.to_integer(100 * product_price(item).last))
    end
  end

end
