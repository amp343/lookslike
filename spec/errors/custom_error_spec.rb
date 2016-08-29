require 'spec_helper'

describe Lookslike::Errors::CustomError do
  it 'should be caught by the expected rescue and have the expected message' do
    message = 'message'
    expect { raise Lookslike::Errors::CustomError.new(message) }.to raise_error Lookslike::Errors::CustomError, message
  end
end
