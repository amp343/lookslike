require 'spec_helper'

def build_validation_rule
  Lookslike::ValidationRule.new('', nil)
end

describe Lookslike::ValidationRule do
  describe '#initialize' do
    it 'should raise TypeError if name is not a string' do
      expect { Lookslike::ValidationRule.new(1, nil, {}) }.to raise_error TypeError, 'name must be a String'
    end

    it 'should raise TypeError if args is not a hash' do
      expect { Lookslike::ValidationRule.new('name', nil, []) }.to raise_error TypeError, 'rules must be a Hash'
    end

    it 'should set @name equal to the name arg' do
      expected = 'name'
      expect(Lookslike::ValidationRule.new(expected, nil).name).to eq expected
    end

    it 'should set @data equal to the data arg' do
      expected = 'data'
      expect(Lookslike::ValidationRule.new('name', expected).data).to eq expected
    end

    it 'should set @rules equal to the rules arg' do
      expected = { rules: true }
      expect(Lookslike::ValidationRule.new('name', nil, expected).rules).to eq expected
    end
  end

  describe '#build_error' do
    it 'should return an instance of the given class with the expected message' do
      rule = Lookslike::ValidationRule.new('name', nil)
      error = TypeError.new 'message'
      decorated = rule.build_error(error)
      expect(decorated.class).to eq TypeError
      expect(decorated.message).to eq 'property name: message'
    end
  end

  #     def build_error(e)
  #       e.class.new('property ' + @name + ': ' + e.message)
  #     end

end


# module LooksLike
#   class ValidationRule
#     # for each defined rule, call
#     # the named validator for that rule
#     def validate
#       begin
#         @rules.map{ |k, v| self.send("validate_" + k.to_s) }
#       rescue Errors::ValidationError => e
#         raise build_error(e)
#       end
#     end
#
#     def build_error(e)
#       e.class.new('property ' + @name + ': ' + e.message)
#     end
#
#     def validate_required
#       raise Errors::RequiredError.new('must be present') if @data.nil?
#     end
#
#     def validate_type(data, type)
#       raise Errors::TypeError.new('must be of type ' + @rules[:type].to_s) unless @data.is_a? @rules[:type]
#     end
#
#     def validate_members
#       #raise Errors::MembersError.new("must be of type " + @type.to_s) unless @data.is_a? @type
#     end
#
#     def validate_custom
#       begin
#         @rules[:custom].call
#       rescue StandardError => e
#         raise Errors::CustomError.new(@rules[:custom_message])
#       end
#     end
#
#     def validate_value
#       if @rules[:value].is_a? Array
#         raise Errors::ValueError.new('must be one of ' + @rules[:value].to_s) unless @data.include? @rules[:value]
#       else
#         raise Errors::ValueError.new('must be equal to ' + @rules[:value]) unless @data == @rules[:value]
#       end
#     end
#
#     def validate_validator
#       @rules[:validator].new(@data).validate
#     end
#
#     def validate_url
#       raise Errors::TypeError.new('must be a valid url') unless @data =~ URI::regexp
#     end
#   end
# end
