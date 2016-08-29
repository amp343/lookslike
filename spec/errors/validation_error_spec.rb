require 'spec_helper'

describe Lookslike::Errors::ValidationError do
  it 'should be caught by the expected rescue and have the expected message' do
    message = 'message'
    expect { raise Lookslike::Errors::ValidationError.new(message) }.to raise_error Lookslike::Errors::ValidationError, message
  end
end
