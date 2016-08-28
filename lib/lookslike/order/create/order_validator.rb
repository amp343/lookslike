module Lookslike
  class Order::Create::OrderValidator < Validator
    def initialize(data)
      super

      add_rule 'object', required: true, value: "Order"
      add_rule 'partner_business_id', required: true
      add_rule 'partner_order_id', required: true
      add_rule 'yelp_order_id',
        custom: Proc.new { Order.find(@data[:yelp_order_id]) if @data[:yelp_order_id].present? },
        custom_message: 'must refer to a valid order'
      add_rule 'order_lines',
        required: true,
        type: Array,
        each_validator: OrderLineItemValidator,
        size: { min: 1 }
    end
  end
end
