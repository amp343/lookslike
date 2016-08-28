require 'spec_helper'

describe Lookslike::Errors::TypeError do
  it 'should have the expected .message' do
    expected = 'message'
    expect(Lookslike::Errors::TypeError.new(expected).message).to eq expected
  end

  it 'should be caught by the expected rescue' do
    begin
      raise Lookslike::Errors::TypeError.new
      expect(true).to eq false
    rescue Lookslike::Errors::TypeError => e
      expect(true).to eq true
    end
  end
end
