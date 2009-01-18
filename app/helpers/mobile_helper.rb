module MobileHelper
  def extract_target_time(time)
    time.strftime("%H:%M") if time
  end

  def exact_datetime_string(datetime)
    datetime.strftime("%m/%d  %H:%M") if datetime
  end

  def record_style(record)
    if record.todo_name == 'sleep' 
      'sleep'
    elsif record.success 
      'bg-lg'
    else
      'target_fail'
    end 
  end

  def show_mobile_messages
    flh =  flash[:notice] || flash[:info]
    "<div class='bg-or pad-5 center '>#{flh}</div>"  if flh
  end

  def link_to_mobile_delete(id)
    link_to 'X', {:controller => 'member', :action => 'destroy', :id => id}, :method => :post
  end
end
