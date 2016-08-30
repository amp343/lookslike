require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#validate_each' do
    context 'when @data is not Enumerable' do
      it 'should raise Errors::TypeError because @rules[:each] is only valid when @data is Enumerable' do
        expect { Lookslike::ValidationRule.new('name', 1, each: { url: true }).validate_each }.to raise_error TypeError
      end
    end

    context 'when @rules[:each] is not a Lookslike::Validator class or Hash' do
      it 'should raise Errors::TypeError because @rules[:each] must be a Lookslike::Validator class or Hash' do
        expect {
          Lookslike::ValidationRule.new('name', [], each: []).validate_each
        }.to raise_error TypeError
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
