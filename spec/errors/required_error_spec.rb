require 'spec_helper'

describe Lookslike::Errors::RequiredError do
  it 'should have the expected .message' do
    expected = 'message'
    expect(Lookslike::Errors::RequiredError.new(expected).message).to eq expected
  end

  it 'should be caught by the expected rescue' do
    begin
      raise Lookslike::Errors::RequiredError.new
      expect(true).to eq false
    rescue Lookslike::Errors::RequiredError => e
      expect(true).to eq true
    end
  end
end
