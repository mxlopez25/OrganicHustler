class PurchaseMailer < ApplicationMailer

  def new_purchase(order)

    oc = OrderConfirmation.create do |o|
      o.confirmation_token = [*('a'..'z'),*('0'..'9'),*('A'..'Z')].shuffle[0,32].join
      o.used = false
      o.limit = Time.now
      o.order_id = order.id
    end
    oc.save!

    p oc

    @cart = order.cart
    @confirmation_token = oc.confirmation_token

    mail to: order.overall_user.email,
         subject: 'Order confirmation'

  end
end
