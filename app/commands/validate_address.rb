class ValidateAddress
  prepend SimpleCommand
  attr_reader :lob, :params

  def initialize(params)
    @params = params
    @lob = Lob::Client.new(api_key: ENV["LOB_API_KEY"])
  end

  def call
    return nil if params.blank?
    address = lob.us_verifications.verify(
      primary_line: "deliverable",
      zip_code: params[:zip_code]
    )
    raise address.inspect
    if address["deliverability"] != "deliverable"
      return false
    else
      return true
    end
  end
end