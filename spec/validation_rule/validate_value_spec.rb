require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#validate_value' do
    context 'when @rules[:value] is a single value' do
      it 'should raise Errors::ValueError if @rules[:value] does not match @data' do
        expect { Lookslike::ValidationRule.new('name', 1, value: 2).validate_value }.to raise_error Lookslike::Errors::ValueError
      end

      it 'should not raise if @rules[:value] matches @data' do
        expect { Lookslike::ValidationRule.new('name', 1, value: 1).validate_value }.to_not raise_error
      end
    end

    context 'when @rules[:value] is an array' do
      it 'should raise Errors::ValueError if @rules[:value] does not contain a match for @data' do
        expect { Lookslike::ValidationRule.new('name', 1, value: [2, 3, 4]).validate_value }.to raise_error Lookslike::Errors::ValueError
      end

      it 'should not raise if @rules[:value] contains a match for @data' do
        expect { Lookslike::ValidationRule.new('name', 1, value: [1, 2, 3]).validate_value }.to_not raise_error
      end
    end
  end
end
