class InactiveUser < ApplicationRecord
  enum status: %i[pending completed]
end
