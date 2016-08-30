module Lookslike
  class ValidationRule

    attr_reader :name, :data, :rules

    def initialize(name, data, rules = {})
      @name       = type_check name, String
      @data       = data
      @rules      = type_check rules, Hash
      @meta_props = [:custom_message]
    end

    # for each defined rule, call
    # the named validator for that rule
    def validate
      begin
        validatable_rules.map{ |k, v| self.send("validate_" + k.to_s) }
      rescue Errors::ValidationError => e
        raise decorate_error e
      end
    end

    def validatable_rules
      @rules.dup.delete_if {|k,v| @meta_props.include? k}
    end

    def decorate_error(e)
      e.class.new "property #{@name}: #{e.message}"
    end

    def validate_required
      raise Errors::RequiredError.new('must be present') if @data.nil?
    end

    def validate_type
      raise Errors::TypeError.new('must be of type ' + @rules[:type].to_s) unless @data.is_a? @rules[:type]
    end

    def validate_members
      #raise Errors::MembersError.new("must be of type " + @type.to_s) unless @data.is_a? @type
    end

    def validate_custom
      proc = type_check(@rules[:custom], Proc)
      begin
        proc.call
      rescue StandardError => e
        raise Errors::CustomError.new(@rules[:custom_message] || '')
      end
    end

    def validate_value
      if @rules[:value].is_a? Array
        raise Errors::ValueError.new('must be one of ' + @rules[:value].to_s) unless @rules[:value].include? @data
      else
        raise Errors::ValueError.new('must be equal to ' + @rules[:value].to_s) unless @data == @rules[:value]
      end
    end

    def validate_validator
      @rules[:validator].new(@data).validate
    end

    def validate_url
      raise Errors::TypeError.new('must be a valid url') unless @data =~ URI::regexp
    end

    def type_check(value, type)
      raise TypeError.new "#{value.to_s} must be a #{type}" unless value.is_a? type
      value
    end

  end
end
