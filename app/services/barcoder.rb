require 'barby'
class Barcoder
  include ActiveModel::Validations
  SYMBOLOGIES = %w[
    code_25 code_25_interleaved code_25_iata code_39
    code_93 code_128 ean_13 bookland ean_8 upc_supplemental
  ].freeze

  OUTPUTTER = %w[
    html svg
  ].freeze

  def initialize(code, symbology = 'code_39', outputter = 'svg')
    @code = code
    @symbology = symbology
    @outputter = outputter
    setup
  end

  def run
    return false unless errors.empty?
    barcode = "Barby::#{@symbology.classify}".constantize.new(@code, true)
    send("to_#{@outputter.downcase}", barcode)
  end

  private

  attr_accessor :symbology, :outputter

  def to_svg(barcode)
    barcode.to_svg.html_safe
  end

  def to_html(barcode)
    barcode.to_html.html_safe
  end

  def setup
    return symbology_error unless SYMBOLOGIES.include?(symbology)
    return outputter_error unless OUTPUTTER.include?(outputter)
    require "barby/barcode/#{symbology}"
    require "barby/outputter/#{outputter}_outputter"
  end

  def symbology_error
    errors.add(:symbology, 'not supported symbology.')
  end

  def outputter_error
    errors.add(:outputter, 'not supported outputter.')
  end
end
