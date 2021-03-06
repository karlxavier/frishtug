module DateTimeHelper
  def months_with_index_options
    date = Date::ABBR_MONTHNAMES
    date.compact.each_with_index.collect { |m, i| [m, i + 1] }.insert(0, ['Month', nil])
  end

  def years_options(start_year = Date.current.year)
    offset_year = Date.current.year + 15
    (start_year..offset_year).to_a.reverse.map { |y| [y, y] }.insert(0, ['Year', nil])
  end

  def time_at(number, format = '%F')
    return 'Cannot convert non integer to time' unless number.is_a? Integer
    Time.at(number).strftime(format)
  end

  def renewal_at(subscription)
    return nil unless current_user.subscribed?
    if subscription.present?
      "Renewal on #{(current_user.subscription_expires_at - 1.days).strftime('%B %d, %Y')}"
    else
      "Subscription will be active on #{current_user.subscribe_at.strftime('%B %d, %Y')}"
    end
  end

  def format_date_AABBDD(date)
    date.to_date.strftime('%^a, %^b %d')
  end

  def current_sale_date(date)
    date.strftime('%B %d')
  end
end
