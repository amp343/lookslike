module Lookslike
  class ValidationRule

    attr_reader :name, :data, :rules

    def initialize(name, data, rules = {})
      type_check name, rules

      @name   = name
      @data   = data
      @rules  = rules
    end

    # for each defined rule, call
    # the named validator for that rule
    def validate
      begin
        @rules.map{ |k, v| self.send("validate_" + k.to_s) }
      rescue Errors::ValidationError => e
        raise build_error(e)
      end
    end

    # TODO: decorate_error?
    def build_error(e)
      e.class.new('property ' + @name + ': ' + e.message)
    end

    def validate_required
      raise Errors::RequiredError.new('must be present') if @data.nil?
    end

    def validate_type(data, type)
      raise Errors::TypeError.new('must be of type ' + @rules[:type].to_s) unless @data.is_a? @rules[:type]
    end

    def validate_members
      #raise Errors::MembersError.new("must be of type " + @type.to_s) unless @data.is_a? @type
    end

    def validate_custom
      begin
        @rules[:custom].call
      rescue StandardError => e
        raise Errors::CustomError.new(@rules[:custom_message])
      end
    end

    def validate_value
      if @rules[:value].is_a? Array
        raise Errors::ValueError.new('must be one of ' + @rules[:value].to_s) unless @data.include? @rules[:value]
      else
        raise Errors::ValueError.new('must be equal to ' + @rules[:value]) unless @data == @rules[:value]
      end
    end

    def validate_validator
      @rules[:validator].new(@data).validate
    end

    def validate_url
      raise Errors::TypeError.new('must be a valid url') unless @data =~ URI::regexp
    end

    protected

    def type_check(name, rules)
      raise TypeError.new 'name must be a String' unless name.is_a? String
      raise TypeError.new 'rules must be a Hash' unless rules.is_a? Hash
    end
  end
end
