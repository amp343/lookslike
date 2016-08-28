require 'spec_helper'

describe Lookslike::Errors::CustomError do
  it 'should have the expected .message' do
    expected = 'message'
    expect(Lookslike::Errors::CustomError.new(expected).message).to eq expected
  end

  it 'should be caught by the expected rescue' do
    begin
      raise Lookslike::Errors::CustomError.new
      expect(true).to eq false
    rescue Lookslike::Errors::CustomError => e
      expect(true).to eq true
    end
  end
end
