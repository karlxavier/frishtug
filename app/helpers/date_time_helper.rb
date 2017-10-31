module DateTimeHelper
  def months_with_index_options
    date = Date::ABBR_MONTHNAMES
    date.compact.each_with_index.collect { |m, i| [m, i + 1] }.insert(0, ['Month'])
  end

  def years_options(start_year = Date.current.year)
    offset_year = Date.current.year + 15
    (start_year..offset_year).to_a.reverse.map { |y| [y, y] }.insert(0, 'Year')
  end
end
