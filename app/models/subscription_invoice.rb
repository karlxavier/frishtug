# frozen_string_literal: true

class SubscriptionInvoice
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def get_invoice
    response = Stripe::Invoice.all(
      customer: user.stripe_customer_id,
      limit: 100
    )
                              .data.keep_if { |s| s[:subscription] == user.stripe_subscription_id }.first

    Response.new(response.nil? ? false : true, response)
  rescue StandardError => e
    Response.new(false, e.message)
  end

  class Response < Struct.new(:success, :response); end
end
