module DateHelpers
  class Weeks
    attr_accessor :date, :start_date
    def initialize(date, start_date = :sunday)
      @date = date
      @start_date = start_date.to_s.to_sym
    end

    def full_month_weeks
      first = date.beginning_of_month.beginning_of_week(start_date)
      last = date.end_of_month.end_of_week(start_date)
      (first..last).to_a.in_groups_of(7)
    end
  end
end