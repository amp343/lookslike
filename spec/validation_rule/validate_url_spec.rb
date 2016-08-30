require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#validate_url' do
    context 'when @rules[:url] is true' do
      it 'should raise Errors::TypeError if @data is not a url' do
        expect {
          Lookslike::ValidationRule.new('name', 'google.com', url: true ).validate_url
        }.to raise_error Lookslike::Errors::TypeError
      end

      it 'should not raise if @data is a url' do
        expect {
          Lookslike::ValidationRule.new('name', 'https://google.com' ).validate_url
        }.to_not raise_error
      end
    end
  end
end
