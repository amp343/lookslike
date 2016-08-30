require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#initialize' do
    it 'should raise TypeError if name is not a string' do
      expect { Lookslike::ValidationRule.new(1, nil, {}) }.to raise_error TypeError, '1 must be a String'
    end

    it 'should raise TypeError if args is not a hash' do
      expect { Lookslike::ValidationRule.new('name', nil, []) }.to raise_error TypeError, '[] must be a Hash'
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

  describe '#decorate_error' do
    it 'should return an instance of the given class with the expected message' do
      rule = Lookslike::ValidationRule.new('name', nil)
      error = TypeError.new 'message'
      decorated = rule.decorate_error(error)
      expect(decorated.class).to eq TypeError
      expect(decorated.message).to eq 'property name: message'
    end
  end

  describe '#validate' do
    it 'should re-raise a built ValidationError error for any ValidationError that is raised' do
      rule = Lookslike::ValidationRule.new('name', nil,
        custom: Proc.new { raise Lookslike::Errors::ValidationError.new 'error' },
        custom_message: 'message'
      )
      expect { rule.validate }.to raise_error Lookslike::Errors::CustomError, 'property name: message'
    end
  end

  describe '#validatable_rules' do
    it 'should return a hash of any @rules whose keys are not in @meta_props' do
      incoming_rules = { required: true, url: true, custom_message: 'message' }
      expected_validatable_rules = { required: true, url: true }
      rule = Lookslike::ValidationRule.new('test', 1, incoming_rules)

      expect(rule.validatable_rules).to eq expected_validatable_rules
      expect(rule.rules).to eq incoming_rules
    end
  end

  describe '#validate_required' do
    it 'should raise Errors::RequiredError if @data is nil' do
      expect { Lookslike::ValidationRule.new('name', nil).validate_required }.to raise_error Lookslike::Errors::RequiredError
    end

    it 'should not raise if @data is present' do
      expect { Lookslike::ValidationRule.new('name', 1).validate_required }.to_not raise_error
    end
  end

  describe '#validate_type' do
    it 'should raise Errors::TypeError if @data is not of type @rules[:type]' do
      expect {
        Lookslike::ValidationRule.new('name', 1, type: String).validate_type
      }.to raise_error Lookslike::Errors::TypeError
    end

    it 'should not raise if @data is of type @rules[:type]' do
      expect { Lookslike::ValidationRule.new('name', 1, type: Integer).validate_type }.to_not raise_error
    end
  end

  describe '#validate_custom' do
    it 'should raise Errors::TypeError if @rules[:custom].call is not a Proc' do
      expect {
        Lookslike::ValidationRule.new('name', 1, custom: 1).validate_custom
      }.to raise_error TypeError
    end

    it 'should raise Errors::CustomError if @rules[:custom].call (Proc) raises StandardError' do
      expect {
        Lookslike::ValidationRule.new('name', 1, custom: Proc.new { raise 'error' }).validate_custom
      }.to raise_error Lookslike::Errors::CustomError
    end

    it 'should not raise if rules[:custom].call does not raise' do
      expect { Lookslike::ValidationRule.new('name', 1, custom: Proc.new {}).validate_custom }.to_not raise_error
    end
  end

  describe '#validate_value' do
    it 'should raise Errors::ValueError if @rules[:value] is a single value and does not match @data' do
      expect { Lookslike::ValidationRule.new('name', 1, value: 2).validate_value }.to raise_error Lookslike::Errors::ValueError
    end

    it 'should raise Errors::ValueError if @rules[:value] is an array and does contain a match for @data' do
      expect { Lookslike::ValidationRule.new('name', 1, value: [2, 3, 4]).validate_value }.to raise_error Lookslike::Errors::ValueError
    end

    it 'should not raise if @rules[:value] is a single value and matches @data' do
      expect { Lookslike::ValidationRule.new('name', 1, value: 1).validate_value }.to_not raise_error
    end

    it 'should not raise if @rules[:value] is an array and contains a match for @data' do
      expect { Lookslike::ValidationRule.new('name', 1, value: [1, 2, 3]).validate_value }.to_not raise_error
    end
  end

  describe '#validate_validator' do
    it 'should raise Errors::ValidationError if @data does validate against the validator specified in @rules[:validator]' do
      expect {
        Lookslike::ValidationRule.new('name', { attr: 100 }, validator: MockValidator ).validate_validator
      }.to raise_error Lookslike::Errors::ValidationError
    end
    it 'should not raise if @data validates against the validator specified in @rules[:validator]' do
      expect {
        Lookslike::ValidationRule.new('name', { attr: "100" }, validator: MockValidator ).validate_validator
      }.to_not raise_error
    end
  end

  describe '#validate_url' do
    it 'should raise Errors::TypeError if @data is not a url and @rules[:url] is true' do
      expect {
        Lookslike::ValidationRule.new('name', 'google.com', url: true ).validate_url
      }.to raise_error Lookslike::Errors::TypeError
    end
    it 'should not raise if @data is a url and @rules[:url] is true' do
      expect {
        Lookslike::ValidationRule.new('name', 'https://google.com' ).validate_url
      }.to_not raise_error
    end
  end

  describe '#validate_each' do
    context 'when @data is not Enumerable' do
      it 'should raise Errors::TypeError because @rules[:each] is only valid when @data is Enumerable' do
        expect { Lookslike::ValidationRule.new('name', 1, each: { url: true }).validate_each }.to raise_error Lookslike::Errors::TypeError
      end
    end

    context 'when @rules[:each] is not a Lookslike::Validator class or Hash' do
      it 'should raise Errors::TypeError because @rules[:each] must be a Lookslike::Validator class or Hash' do
        expect {
          Lookslike::ValidationRule.new('name', [], each: []).validate_each
        }.to raise_error Lookslike::Errors::TypeError
      end
    end

    context 'when @rules[:each] is a Hash' do
      it 'should validate each member of @data against a Lookslike::ValidationRule derived from the ruleset supplied by @rules[:each] and raise the Error raised by that particular method if any member fails' do
        expect {
          Lookslike::ValidationRule.new('name', ['google.com', 'http://google.com'], each: { url: true }).validate_each
        }.to raise_error Lookslike::Errors::TypeError
      end

      it 'should validate each member of @data against a Lookslike::ValidationRule derived from the ruleset supplied by @rules[:each] and not raise if all members pass' do
        expect {
          Lookslike::ValidationRule.new('name', ['https://yahoo.com', 'http://google.com'], each: { url: true }).validate_each
        }.to_not raise_error
      end
    end

    context 'when @rules[:each] is a Lookslike::Validator class' do
      it 'should validate each member of @data against an instance of @rules[:each] and raise Errors::ValidationError if any member fails' do
        expect {
          Lookslike::ValidationRule.new('name', [{ attr: 100 }, { attr: "100" }], each: MockValidator ).validate_each
        }.to raise_error Lookslike::Errors::ValidationError
      end

      it 'should validate each member of @data against an instance of @rules[:each] and not raise if all members pass' do
        expect {
          Lookslike::ValidationRule.new('name', [{ attr: "100" }, { attr: "100" }], each: MockValidator).validate_each
        }.to_not raise_error
      end
    end
  end
end
