require 'spec_helper'

describe Lookslike::Errors::TypeError do
  it 'should be caught by the expected rescue and have the expected message' do
    message = 'message'
    expect { raise Lookslike::Errors::TypeError.new(message) }.to raise_error Lookslike::Errors::TypeError, message
  end
end
