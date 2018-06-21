class TaxCalculator
  TAX = Tax.first.rate
  attr_reader :amount, :rate

  def initialize(amount)
    @amount = amount
    @rate = (TAX / 100.0).to_d
  end

  def calculate
    price = convert_to_cents(amount)
    convert_to_dollars(price * rate)
  end

  private

  def convert_to_cents(num)
    MoneyConverter.new(num).to_cents
  end

  def convert_to_dollars(num)
    MoneyConverter.new(num).to_dollars
  end
end