module MainHelper
  WEEK_DAYS = %w(日 一 二 三 四 五 六)
  
  def today_show
    now = Time.now
    wday = WEEK_DAYS[now.wday]
    today = now.to_date
    "今天是#{today} 星期#{wday} 目前共有鳥友#{@num}名"
  end

end
