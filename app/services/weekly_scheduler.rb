class WeeklyScheduler < ScheduleMaker

  def initialize(user)
    @user = user
    @schedule = user.schedule.try(:option)
    @last_five_orders = user.orders.first(5)
    @orders = user.orders
    @number_to_generate = @orders.count % 20 == 0 ? 20 : 15
  end

  def create_schedule!
    generate_schedule(@number_to_generate)
  end

  def create_schedule_for_selection!
    create_selection_from(generate_schedule(@number_to_generate))
  end

  def get_schedules_for_selection!
    @orders.order(placed_on: :asc).in_groups_of(5).map do |o|
      o = o.compact
      if o.count == 5
        [
          "#{format_date(o.first&.placed_on)} - #{format_date(o.last&.placed_on)}",
          o.map(&:id).join(',')
        ]
      end
    end
  end

  private

  attr_accessor :user

  def create_selection_from(results)
    return nil unless results.present?
    range = DateRange.new(results.first.beginning_of_day, results.last.end_of_day)
    dates = user.orders.placed_between?(range).map { |o| o.placed_on.to_date }
    results = results - dates
    results.in_groups_of(5).map do |r|
      ["#{format_date(r.first)} - #{format_date(r.last)}", r.join(',')]
    end
  end

  def format_date(date)
    date&.strftime('%b %d')
  end
end
