class MockValidator < Lookslike::Validator
  def initialize(data)
    super

    add_rule 'attr', required: true, value: "100"

  end
end
