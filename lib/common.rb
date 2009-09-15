module Common
  def self.cal_days_interval(time1, time2)
    interval_days = ((time2 - time1)/86400).to_i
    interval_days = 1 if interval_days.zero?
    interval_days
  end
end
