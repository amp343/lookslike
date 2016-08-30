require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#initialize' do
    context 'when name is not a string' do
      it 'should raise TypeError' do
        expect { Lookslike::ValidationRule.new(1, nil, {}) }.to raise_error TypeError, '1 must be a String'
      end
    end

    context 'if args is not a hash' do
      it 'should raise TypeError' do
        expect { Lookslike::ValidationRule.new('name', nil, []) }.to raise_error TypeError, '[] must be a Hash'
      end
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
end
