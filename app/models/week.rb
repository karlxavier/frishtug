# An object that returns the number of weeks in a year
class Week
  def initialize(year = Date.current.year)
    @year = year
    @date = Date.new(year, 1, 1)
  end

  def number_of_weeks
    return 53 if starts_on_thursday?
    return 53 if leap_year_and_starts_on_wednesday?
    52
  end

  private

  attr_accessor :date

  def starts_on_thursday?
    date.wday == 4
  end

  def leap_year_and_starts_on_wednesday?
    date.leap? && date.wday == 3
  end
end