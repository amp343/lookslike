require 'spec_helper'

describe Lookslike::Errors::ValidationError do
  it 'should have the expected .message' do
    expected = 'message'
    expect(Lookslike::Errors::ValidationError.new(expected).message).to eq expected
  end

  it 'should be caught by the expected rescue' do
    begin
      raise Lookslike::Errors::ValidationError.new
      expect(true).to eq false
    rescue Lookslike::Errors::ValidationError => e
      expect(true).to eq true
    end
  end
end
