module Lookslike
  class Validator
    def initialize(data)
      @data = data
      @rules = []
    end

    def validate
      begin
        @rules.map{ |x| x.validate }
      rescue Errors::ValidationError => e
        raise build_error(e)
      end
      true
    end

    def add_rule(param_name, rules = {})
      @rules << ValidationRule.new(param_name, @data[param_name.to_sym], rules)
    end

    def build_error(e)
      Errors::ValidationError.new((@name.present? ? @name + ' ' : '') + e.message)
    end
  end
end
