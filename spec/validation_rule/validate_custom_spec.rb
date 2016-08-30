require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#validate_custom' do
    context 'when @rules[:custom].call is not a Proc' do
      it 'should raise TypeError' do
        expect {
          Lookslike::ValidationRule.new('name', 1, custom: 1).validate_custom
        }.to raise_error TypeError
      end
    end

    context 'when @rules[:custom].call (Proc) raises StandardError' do
      it 'should raise Errors::CustomError' do
        expect {
          Lookslike::ValidationRule.new('name', 1, custom: Proc.new { raise 'error' }).validate_custom
        }.to raise_error Lookslike::Errors::CustomError
      end
    end

    context 'when @rules[:custom].call does not raise' do
      it 'should not raise' do
        expect { Lookslike::ValidationRule.new('name', 1, custom: Proc.new {}).validate_custom }.to_not raise_error
      end
    end
  end
end
