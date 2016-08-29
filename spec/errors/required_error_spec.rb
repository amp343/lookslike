require 'spec_helper'

describe Lookslike::Errors::RequiredError do
  it 'should be caught by the expected rescue and have the expected message' do
    message = 'message'
    expect { raise Lookslike::Errors::RequiredError.new(message) }.to raise_error Lookslike::Errors::RequiredError, message
  end
end
