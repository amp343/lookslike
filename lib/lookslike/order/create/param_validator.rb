module Lookslike
  class Order::Create::ParamValidator < Validator
    def initialize(data)
      super

      add_rule 'order', required: true, validator: Order::Create::OrderValidator
      add_rule 'notification_url', required: true
      add_rule 'opportunity_id', required: true,
        custom: Proc.new { Opportunity.find(@data[:opportunity_id]) },
        custom_message: 'must refer to a valid opportunity'
    end
  end
end
