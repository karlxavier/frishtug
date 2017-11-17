# Calendar.new(self, date, block).table
# inside a helper e.g
# def calendar(date = Date.today, &block)
#   Calendar.new(self, date, block)
# end
class Calendar
  HEADER = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze
  HEADER_COMPACT = %w[S M T W T F S].freeze
  START_DAY = :sunday

  delegate :content_tag, to: :view
  attr_accessor :view, :date, :block

  def initialize(view, date, block)
    @view = view
    @date = date
    @block = block
  end

  def table
    content_tag :table, class: 'calendar table table-bordered' do
      table_head + table_body
    end
  end

  def table_compact
    content_tag :table, class: 'calendar table table-bordered table-sm' do
      compact_table_head + table_body
    end
  end

  def compact_table_head
    content_tag :thead do
      HEADER_COMPACT.map { |day| content_tag :th, day, class: 'text-center' }.join.html_safe
    end
  end

  def table_head
    content_tag :thead do
      HEADER.map { |day| content_tag :th, day, class: 'text-center' }.join.html_safe
    end
  end

  def table_body
    content_tag :tbody do
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| cell(day) }.join.html_safe
        end
      end.join.html_safe
    end
  end

  def cell(day)
    content_tag :td, view.capture(day, &block), class: "text-center #{classes(day)}"
  end

  def classes(day)
    klasses = []
    klasses << 'today' if day == Date.today
    klasses << 'not-month' if day.month != date.month
    klasses.empty? ? nil : klasses.join(' ')
  end

  def weeks
    first = date.beginning_of_month.beginning_of_week(START_DAY)
    last = date.end_of_month.end_of_week(START_DAY)
    (first..last).to_a.in_groups_of(7)
  end
end
