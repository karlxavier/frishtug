class Schedule < ApplicationRecord
  enum option: %i[monday_to_friday sunday_to_thursday]
  belongs_to :user
end
