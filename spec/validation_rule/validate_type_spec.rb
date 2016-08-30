require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#validate_type' do
    context 'when @data is not of type @rules[:type]' do
      it 'should raise Errors::TypeError' do
        expect {
          Lookslike::ValidationRule.new('name', 1, type: String).validate_type
        }.to raise_error Lookslike::Errors::TypeError
      end
    end

    context 'when @data is of type @rules[:type]' do
      it 'should not raise' do
        expect { Lookslike::ValidationRule.new('name', 1, type: Integer).validate_type }.to_not raise_error
      end
    end
  end
end
