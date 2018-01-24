class TransactionalMailer < ApplicationMailer

  layout 'trasactional_mm'

  def shipped_out(order)
    @order = order

    products_partial = []
    order.cart.cart_products.each do |cp|
      ne_p = cp.as_json
      ne_p.merge!('qty' => 1)
      ne_p.merge!('consolidated' => false)
      products_partial << ne_p
    end

    products = products_partial

    (0..products_partial.length - 1).each {|i|

      pr = products_partial[i]

      unless pr['consolidated']
        products_partial.each do |dl|
          if dl['id'] != pr['id'] && pr['size_id'] == dl['size_id'] && pr['has_emblem'] == dl['has_emblem'] && pr['has_logo'] == false && dl['has_logo'] == false && pr['product_id'] == dl['product_id']
            tem_pr = CartProduct.find(pr['id'])
            tem_dl = CartProduct.find(pr['id'])

            if tem_pr.custom_emblems == tem_dl.custom_emblems
              dl['consolidated'] = true
              products[i]['qty'] = products[i]['qty'] + 1
            end
          end
        end
      end
    }

    @cart_products = {
        tax_array: [],
        cost_array: [],
        products: []
    }

    products.each do |product|

      pr_price = product_price(product['id'])
      @cart_products[:tax_array].push(pr_price[1])
      @cart_products[:cost_array].push(pr_price[5])

      unless product['consolidated']

        product['data'] = Product.find product['product_id']
        product['size'] = Size.find product['size_id']
        product['color'] = Color.find product['color_id']
        product['price_sgl'] = format('$%.2f', pr_price[5])
        @cart_products[:products].push(product)
      end

    end

    c = order.cart
    cart_p = c.promotion_codes.first.try(:rate)
    cart_g = c.gifts.first.try(:rate)
    @cart_products.merge!('discount' => (cart_p || cart_g || {rate: 0}))

    mail to: @order.overall_user.email, subject: 'Your order is being ready for shipment'
  end

  def delivered

  end

  def canceled_order

  end

  def open_order

  end

  def canceled_shipment

  end

  def support_message(ticket)
    @ticket = ticket
    @token = get_random_string(8)

    ticket.respond_token = @token
    ticket.valid_token = true
    ticket.save!

    mail to: @ticket.temp_user.email, subject: 'OrganicHustler Support'
  end

  def product_canceled

  end

  def subscription_confirmation

  end

  def tracking

  end

  private

  def product_price(p_cart_id)
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

  def get_random_string(length=5)
    source=("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a + ["_", "-", "."]
    key=""
    length.times{ key += source[rand(source.size)].to_s }
    key
  end

end
