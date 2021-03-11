module Customer::OrdersHelper
  def reciveDate
    if Time.current.hour >= 15
      Time.current.tomorrow
    else
       Date.today
    end
  end

  def orderTime
    %w(15:00 15:30 16:00 16:30 17:00 17:30 18:00 18:30 19:00 19:30)
  end

end
