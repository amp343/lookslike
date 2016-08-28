require 'spec_helper'

describe Lookslike::Errors::ValueError do
  it 'should have the expected .message' do
    expected = 'message'
    expect(Lookslike::Errors::ValueError.new(expected).message).to eq expected
  end

  it 'should be caught by the expected rescue' do
    begin
      raise Lookslike::Errors::ValueError.new
      expect(true).to eq false
    rescue Lookslike::Errors::ValueError => e
      expect(true).to eq true
    end
  end
end
