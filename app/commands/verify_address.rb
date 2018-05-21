class VerifyAddress
  prepend SimpleCommand

  def initialize(params)
    @line1 = params[:line1]
    @line2 = params[:line2]
    @city = params[:city]
    @zip = params[:zip_code]
  end

  def call
    verifiable_address = EasyPost::Address.create(
      verify: ["delivery"],
      street1: @line1,
      street2: @line2,
      city: @city,
      state: @state,
      zip: @zip,
      country: "US",
    )

    delivery = verifiable_address.verifications.delivery

    if delivery.success
      return delivery.details
    else
      delivery.errors.each do |error|
        errors.add(:address, error.message)
      end
      return false
    end
  end
end