require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#validate_validator' do
    context 'when @data does validate against the validator specified in @rules[:validator]' do
      it 'should raise Errors::ValidationError' do
        expect {
          Lookslike::ValidationRule.new('name', { attr: 100 }, validator: MockValidator ).validate_validator
        }.to raise_error Lookslike::Errors::ValidationError
      end
    end
    context 'when @data validates against the validator specified in @rules[:validator]' do
      it 'should not raise' do
        expect {
          Lookslike::ValidationRule.new('name', { attr: "100" }, validator: MockValidator ).validate_validator
        }.to_not raise_error
      end
    end
  end
end
