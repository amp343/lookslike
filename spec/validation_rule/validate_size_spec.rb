require 'spec_helper'

describe Lookslike::ValidationRule do
  describe '#validate_size' do
    context 'when @rules[:size] is no an Integer value or Hash of Integer values' do
      it 'should raise TypeError' do
        expect { Lookslike::ValidationRule.new('name', [], size: 'abc').validate_size }.to raise_error TypeError
        expect { Lookslike::ValidationRule.new('name', [], size: { min: 'abc' }).validate_size }.to raise_error TypeError
      end
    end

    context 'when @data is not an Array' do
      it 'should raise TypeError' do
        expect { Lookslike::ValidationRule.new('name', 1, size: 1).validate_size }.to raise_error TypeError
      end
    end

    context 'when @data is an Array' do
      context 'when @rules[:size] is a single Integer value' do
        it 'should raise Lookslike::Errors::SizeError if the size of @data does not match @rules[:size]' do
          expect { Lookslike::ValidationRule.new('name', [1, 2], size: 1).validate_size }.to raise_error Lookslike::Errors::SizeError
        end

        it 'should not raise if the size of @data is exactly @rules[:size]' do
          expect { Lookslike::ValidationRule.new('name', [1, 2], size: 2).validate_size }.to_not raise_error
        end
      end

      context 'when @rules[:size] is a Hash of Integer values' do
        context 'when @rules[:size] has only key :min' do
          it 'should raise Lookslike::Errors::SizeError if the size of @data is < @rules[:size][:min]' do
            expect { Lookslike::ValidationRule.new('name', [1, 2], size: { min: 3 }).validate_size }.to raise_error Lookslike::Errors::SizeError
          end

          it 'should not raise if the size of @data is >= @rules[:size][:min]' do
            expect { Lookslike::ValidationRule.new('name', [1, 2], size: { min: 2 }).validate_size }.to_not raise_error
          end
        end

        context 'when @rules[:size] has only key :max' do
          it 'should raise Lookslike::Errors::SizeError if the size of @data is > @rules[:size][:max]' do
            expect { Lookslike::ValidationRule.new('name', [1, 2, 3, 4], size: { max: 3 }).validate_size }.to raise_error Lookslike::Errors::SizeError
          end

          it 'should not raise if the size of @data is <= @rules[:size][:max]' do
            expect { Lookslike::ValidationRule.new('name', [1, 2], size: { max: 2 }).validate_size }.to_not raise_error
          end
        end

        context 'when @rules[:size] has keys :max and :min' do
          it 'should raise Lookslike::Errors::SizeError if the size of @data is > @rules[:size][:max]' do
            expect { Lookslike::ValidationRule.new('name', [1, 2, 3, 4], size: { min: 1, max: 3 }).validate_size }.to raise_error Lookslike::Errors::SizeError
          end

          it 'should raise Lookslike::Errors::SizeError if the size of @data is < @rules[:size][:min]' do
            expect { Lookslike::ValidationRule.new('name', [1, 2], size: { min: 3, max: 4 }).validate_size }.to raise_error Lookslike::Errors::SizeError
          end

          it 'should not raise if the size of @data is @rules[:size][:min] <= @data.length <= @rules[:size][:max]' do
            expect { Lookslike::ValidationRule.new('name', [1, 2], size: { min: 2, max: 4 }).validate_size }.to_not raise_error
            expect { Lookslike::ValidationRule.new('name', [1, 2, 3], size: { min: 2, max: 4 }).validate_size }.to_not raise_error
            expect { Lookslike::ValidationRule.new('name', [1, 2, 3, 4], size: { min: 2, max: 4 }).validate_size }.to_not raise_error
          end
        end
      end
    end
  end
end
