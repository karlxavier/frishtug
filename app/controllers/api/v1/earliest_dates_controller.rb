class Api::V1::EarliestDatesController < Api::V1::BaseController
  def index
    @date = Time.current
    @earliest_monday = @date.sunday? ? (@date +1.day).next_week(:monday) : @date.next_week(:monday)
    @earliest_sunday = next_sunday
    render json: {
      earliest_monday: @earliest_monday,
      earliest_sunday: @earliest_sunday
    }, status: :ok
  end

  private

  def next_monday_if_past_noon
    @date >= closed_time ? @date.next_week(:monday) : @date
  end

  def next_sunday_if_past_noon
    @date >= closed_time ? @date + 7.days : @date
  end

  def closed_time
    Time.zone.parse '11:00 am'
  end

  def next_sunday
    days_to_add = 7 - @date.wday
    return @date + days_to_add.days if days_to_add > 0
    @date.next_week(:sunday)
  end
end