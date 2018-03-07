module User::BillHistoriesHelper
  def to_dollar(cents)
    (cents.to_d / 100).to_d
  end
end