class WeeklyScheduler < ScheduleMaker

  def create_schedule!
    generate_schedule
  end

  def create_schedule_for_selection!
    create_selection_from(generate_schedule)
  end

  def get_schedules_for_selection!
    @orders.order(placed_on: :asc).in_groups_of(5, false).map do |o|
      create_array_of_dates(o)
    end
  end

  private

  attr_accessor :user

  def create_array_of_dates(list)
    list = list.compact
    if list.count == 5
      return [
        "#{format_date(list.first&.placed_on)} - #{format_date(list.last&.placed_on)}",
        list.map(&:id).join(',')
      ]
    end
  end

  def create_selection_from(results)
    return nil unless results.present?
    results = results - removable_dates
    results.in_groups_of(5, false).map do |r|
      ["#{format_date(r.first)} - #{format_date(r.last)}", r.join(',')]
    end
  end

  def removable_dates
    user.orders
        .where.not(status: [:fulfilled, nil]).pluck(:placed_on).map(&:to_date)
  end

  def format_date(date)
    date&.strftime('%b %d')
  end
end
