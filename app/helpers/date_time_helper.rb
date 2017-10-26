module DateTimeHelper
  def months_with_index_options
    date = Date::ABBR_MONTHNAMES
    date.compact.each_with_index.collect { |m, i| [m, i+1] }.insert(0, ['Month'])
  end

  def years_options(start_year = 1990)
    year_now = Date.current.year
    (start_year..year_now).to_a.reverse.map { |y| [y, y] }.insert(0, 'Year')
  end
end