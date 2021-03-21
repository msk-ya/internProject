module Customer::OrdersHelper
  def reciveDate
    if Time.current.hour >= 15
      Time.current.tomorrow
    else
       Date.today.strftime
    end
  end

  def openDate
    if Time.current.hour >= 15
      Time.current.tomorrow.strftime("%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[Time.current.tomorrow.wday]})")
    else
       Date.today.strftime("%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[Date.today.wday]})")
    end
  end

  def orderTime
    %w(15:00 15:30 16:00 16:30 17:00 17:30 18:00 18:30 19:00 19:30)
  end

end
