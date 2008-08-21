module AllHelper 
  WEEK_DAYS = %w(日 一 二 三 四 五 六)
  def exact_datetime_string(datetime)
    datetime.strftime("%m/%d  %H:%M")
  end

  def select_week
    "<select id='week', name='week'>
      #{options_for_select(TargetsController::WEEK_OPTIONS)}
    </select>"
  end


  def link_tab(links)
    html = []
    links.each do |l|
      if l[1] == 'member' and controller.controller_name == 'member' and controller.action_name == l[2] and @user == @me
          html << "<li class = 'current'>#{l[0]}</li>"
      elsif l[1] == 'member'
        html << "<li>#{link_to(l[0], {:controller => l[1], :action => l[2], :id => session[:uid]} )}</li>"
      elsif controller.controller_name == l[1] and controller.action_name == l[2] 
          html << "<li class = 'current'>#{l[0]}</li>"
      else
        html << "<li>#{link_to(l[0], {:controller => l[1], :action => l[2] } )}</li>"
      end
    end
    html.join
  end

  #目標時間05:10
  def extract_target_time(time)
    time.strftime("%H:%M") if time
  end

  def exact_target_time(user)
    if time = user.target_time
        "今日目標 #{extract_target_time(time)}"
    else
      link_to "<font color='red'>你尚未設定目標起床時間</font>", :controller => 'member', :action => 'list'
    end
  end

  #今天是X年X月X日 ...
  def extract_datetime_string(datetime)
    datetime.strftime("%Y年%m月%d日  %H:%M") if datetime
  end

  def page_index(rec, i, asc=true)
     n = ((rec.current_page-1) * rec.per_page)+i
     if asc 
       n.zero? ? image_tag("bird.gif") : n+1
     else
       rec.total_entries - n
     end
  end

  def all_average(user)
      %[平均時間#{user.status.average.strftime("%H:%M")}] if user.status.average
  end

  def diff_value(user)
      "平均離目標#{user.status.diff}分" if user.status.diff and user.target_time_now
  end

  def exact_score(user)
      "分數#{user.status.score}分" if user.status.score
  end

  def success_census(user)
      "成功率為#{ number_to_percentage(user.status.success_rate, :precision => 1) || 0}"
  end

  def continuous_success_num(user)
    num = user.status.continuous_num
    if !num 
     "連續早起0次"
    elsif num < 0
     "<span class='alert'>連續晚起 #{num.abs || 0}次</span>"
    else
     "連續早起 #{num.abs || 0}次"
    end
  end

  def show_messages
    flh =  flash[:notice] || flash[:info]
    "<span class='alert'>#{flh}</span>"  if flh
  end

  def link_to_user(u, text, cls=nil, img=false)
    str = "<span class='user_photo_small'>"
    if u.mugshot && img
      str << "#{link_to image_tag(u.mugshot.public_filename(:small), :size =>'30x30'), {:controller => 'member', :action => 'list', :id => u}}</span>"
    elsif img
      str << "#{link_to image_tag("penguin_small.jpg"),{ :controller => 'member', :action => 'list', :id => u}}</span>"
    end
    str << "#{link_to h(text), {:controller => 'member', :action => 'list', :id => u}, :class => cls}"     
  end

  def link_to_user_image(u, cls)
    if u.mugshot
      "#{link_to image_tag(u.mugshot.public_filename, :size => '100x100'),
        {:controller => 'member', :action => 'list', :id => u}, :class => cls}"
    else
      "#{link_to image_tag("penguin.jpg", :size => '100x100'),
        { :controller => 'member', :action => 'list', :id => u}, :class => cls}"
    end
  end

  def where_is_me(u, text)
    if @me
      if @me.id == u.id
        link_to_user(u, text, 'alert', true)
      else
        link_to_user(u, text, nil, true)
      end
    else
      link_to_user(u, text, nil, true)
    end
  end

  def link_to_diary(r, text, size=32)
    link_to format_content(truncate(text, size)), :controller => 'member', :action => 'show', :id => r
  end

  def month_selected
    params[:date].nil? ? Time.now.month : params[:date][:month].to_i 
  end

  def year_selected
    params[:date].nil? ? Time.now.year : params[:date][:year].to_i 
  end

  def link_to_delete(con, id)
    link_to image_tag("delete.png",
                      :border => "0",
                      :mouseover => image_path("delete_over.gif")),
                      {:controller => con, :action => 'destroy', :id => id},
                      :confirm => '妳確定要刪除嗎?', :method => :post
  end

  def ajax_link_to_delete
    link_to image_tag("delete.png",
                      :border => "0")
  end

  def ck_box(item, opt, checked)
    checked = checked == 1 ? true : false
    check_box_tag("item[#{item.id.to_s}][#{opt}]", 1, checked )
  end

  def text_fields(item, comment)
    text_field_tag "item["+item.id.to_s+"][comment]", comment
  end

  def state_image(done, img1='plus.gif', img2='minus.gif')
    image = done ? image_tag(img1) : image_tag(img2)
  end

  HTTP_REGEX = /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/[A-Za-z\.0-9_\+\?%\/=&]*)?)/ix

  def format_content(content)
    c = content
    return '' if c.blank?

    return c.gsub(/\r\n/, "\n").gsub(/\n/) { |e|
      "<br />" unless $` =~/<br \/>$/
    } 
  end

  def full_format_content(content)
    c = content
    return '' if c.blank?

    return c.gsub(/\r\n/, "\n").gsub(/\n/) { |e|
      "<br />" unless $` =~/<br \/>$/
    }.gsub(HTTP_REGEX) do  |e| 
      if $` =~/href=(?:"|')$/ 
        e
      else 
        "<a href='#{e}'>#{e}</a>"
      end
    end
  end

  def need_accepter(user, call_id)
    if user
      "#{link_to_user(user, user.name)}"
    else
      link_to '我可以幫忙,', {:controller => 'calls', :action => 'update', :id => call_id},
                                :confirm => '妳確定要幫忙嗎?', :method => :post
    end
  end

  def link_to_cancel(col = "member")
    link_to '取消',:controller => col, :action => 'list'
  end

  def week_day(day)
    if [0, 6].include?(day)
      "<font color='red'>#{WEEK_DAYS[day]}</font>"
    else
      WEEK_DAYS[day]
    end
  end

  def is_owner?(user)
    if @me
      is_owner = @me.id == user.id ? true : false
    else
      false
    end
  end

  def link_to_group(text, id)
    link_to text, :controller => 'groups', :action => 'show', :id => id
  end

  def link_to_my_group
    if @me.group
      link_to @me.name+"的早鳥團", :controller => 'groups', :action => 'show', :id => @me.group_id
    else
      "<span class='alert'>
      #{link_to '妳還沒有參加任何的早起團', :controller => 'groups', :action => 'index'}
      </span>"
    end
  end

  def big_mugshot(user)
    if user.mugshot
      image_tag(user.mugshot.public_filename)
    else 
      image_tag("penguin.jpg")
    end
  end

  def today_show
    now = Time.now
    wday = week_day(now.wday)
    today = now.to_date
    "今天是#{today} 星期#{wday} 目前共有鳥友#{@num}名"
  end

  def week_day(wday)
    WEEK_DAYS[wday]
  end

end
