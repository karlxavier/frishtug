class NullScanovator
  class ToDate
    def to_date
      NullScanovator::Time.new
    end
  end

  class Time
    def strftime args
      '00:00'
    end
  end

  class Data
    def actually_delivered
      ''
    end

    def eta
      NullScanovator::ToDate.new
    end

    def route_started
      ''
    end

    def payment_details
      ''
    end
  end

  def data
    [NullScanovator::Data.new]
  end

  def state
    'success'
  end
end
