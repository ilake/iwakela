ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :ymd => '%Y年%m月%d日',
  :ym => '%Y年%m月',
  :date => "%Y年%m月%d日  %H:%M",
  :mdate => "%Y/%m/%d %H:%M",
  :md => "%m月%d日",
  :time => "%m/%d  %H:%M",
  :hm => "%H:%M"
)

