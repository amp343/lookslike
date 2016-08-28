module Lookslike
  class OrderValidator
    def self.validate_create(params)
      Order::Create::ParamValidator.new(params).validate
    end
  end
end
