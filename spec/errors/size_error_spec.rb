require 'spec_helper'

describe Lookslike::Errors::SizeError do
  it 'should be caught by the expected rescue and have the expected message' do
    message = 'message'
    expect { raise Lookslike::Errors::SizeError.new(message) }.to raise_error Lookslike::Errors::SizeError, message
  end
end
