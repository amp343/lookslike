require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#validate_required' do
    context 'when @data is nil' do
      it 'should raise Errors::RequiredError' do
        expect { Lookslike::ValidationRule.new('name', nil).validate_required }.to raise_error Lookslike::Errors::RequiredError
      end
    end

    context 'when @data is present' do
      it 'should not raise' do
        expect { Lookslike::ValidationRule.new('name', 1).validate_required }.to_not raise_error
      end
    end
  end
end
