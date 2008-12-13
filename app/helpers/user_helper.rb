module UserHelper
  def today_show
    now = Time.now
    wday = week_day(now.wday)
    today = now.to_date
    "今天是#{today} 星期#{wday} 目前共有鳥友#{@num}名"
  end

end
