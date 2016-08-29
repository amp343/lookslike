require 'spec_helper'

describe Lookslike::Errors::ValueError do
  it 'should be caught by the expected rescue and have the expected message' do
    message = 'message'
    expect { raise Lookslike::Errors::ValueError.new(message) }.to raise_error Lookslike::Errors::ValueError, message
  end
end
