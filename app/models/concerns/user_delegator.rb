# frozen_string_literal: true

module UserDelegator
  extend ActiveSupport::Concern

  DELEGATABLE_FIELD = %i[
    first_name
    last_name
    email
    plan
    addresses
  ].freeze

  included do
    delegate *DELEGATABLE_FIELD, to: :user, prefix: true, allow_nil: true
  end
end
