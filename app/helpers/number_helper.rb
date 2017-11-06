module NumberHelper
  def monefy(number, unit='$')
    number_to_currency number, unit: unit, precession: 2, format: '%u %n'
  end
end