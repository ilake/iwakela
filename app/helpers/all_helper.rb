module AllHelper 
  WEEK_DAYS = %w(日 一 二 三 四 五 六)
  #SCORE_STATE = [38, 32, 20, 6, -6,-18,-30, -40, -48, -10000]
  SCORE_STATE = [90, 80, 70, 60, 50, 40, 30, 20, 10, -1]

  def exact_datetime_string(datetime)
    datetime.strftime("%m/%d  %H:%M") if datetime
  end

  def extract_date_string(datetime)
    datetime.strftime("%Y年%m月%d日") if datetime
  end

  #今天是X年X月X日 ...
  def extract_datetime_string(datetime)
    datetime.strftime("%Y年%m月%d日  %H:%M") if datetime
  end


  def select_week
    "<select id='week', name='week'>
      #{options_for_select(TargetsController::WEEK_OPTIONS)}
    </select>"
  end


  def link_tab(links)
    html = []
    links.each do |l|
      if @user == @me and (l[1] == 'member' or l[1] == 'messages') and (controller.controller_name == 'member' or controller.controller_name == 'messages')
          html << "<li class = 'current'>#{t(l[0])}</li>"
      elsif l[1] == 'member'
        html << "<li>#{link_to(t(l[0]), {:controller => l[1], :action => l[2], :id => session[:uid]} )}</li>"
      elsif controller.controller_name == l[1] and controller.action_name == l[2] 
          html << "<li class = 'current'>#{t(l[0])}</li>"
      else
        html << "<li>#{link_to(t(l[0]), {:controller => l[1], :action => l[2] } )}</li>"
      end
    end
    html.join
  end

  SUB_MENU_CON = ['messages', 'member', 'user', 'friend']
  def link_sub_tab(links)
    html = []
    links.each do |l|
      if SUB_MENU_CON.include?(l[1]) and SUB_MENU_CON.include?(controller.controller_name) and controller.action_name == l[2]
          html << "<li class = 'current'>#{t(l[0])}</li>"
      elsif SUB_MENU_CON.include?(l[1])
        html << "<li>#{link_to(t(l[0]), {:controller => l[1], :action => l[2], :id => @user} )}</li>"
      elsif controller.controller_name == l[1] and controller.action_name == l[2] 
          html << "<li class = 'current'>#{t(l[0])}</li>"
      else
        html << "<li>#{link_to(t(l[0]), {:controller => l[1], :action => l[2] } )}</li>"
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
        "#{t('sider.today_target')}: #{extract_target_time(time)}"
    else
      link_to "<font color='red'>尚未設定目標起床時間</font>", :controller => 'member', :action => 'list'
    end
  end

  def page_index(rec, i, asc=true)
     n = ((rec.current_page-1) * rec.per_page)+i
     if asc 
       n.zero? ? b_image_tag("bird.gif") : n+1
     else
       rec.total_entries - n
     end
  end

  def all_average(user)
      %[#{t('sider.average')}#{user.status.average.strftime("%H:%M")}] if user.status.average
  end

  def diff_value(user)
      "#{user.status.diff}分" if user.status.diff and user.target_time_now
  end

  def exact_score(user)
      "分數#{user.status.score}分" if user.status.score
  end

  def success_census(user)
      num = user.status.continuous_num
      if !num 
      elsif num < 0
        st = b_image_tag('arrow_down.png', :alt => '退步', :title => '退步' )
      else
        st = b_image_tag('arrow_up.png', :alt => '進步', :title => '進步' )
      end

      "#{t('sider.rate')}#{ number_to_percentage(user.status.success_rate, :precision => 1) || 0} #{st}"
  end

  def continuous_success_num(user)
    num = user.status.continuous_num
    if !num 
     "早起0次"
    elsif num < 0
     "<span class='alert'>晚起 #{num.abs || 0}次</span>"
    else
     "早起 #{num.abs || 0}次"
    end
  end

  def show_messages
    flh =  flash[:notice] || flash[:info]
    "<div class='bg-or pad-10 mar-b-10 w-black fw-bold center rounded'>#{flh}</div>"  if flh
  end

  def link_to_user(u, text, cls=nil, img=false)
    str = "<span class='user_photo_small'>"
    if img && u.mugshot
      str << "#{link_to image_tag(u.mugshot.public_filename(:small), :size =>'30x30'), {:controller => 'member', :action => 'journal', :id => u}}</span>"
    elsif img
      str << "#{link_to b_image_tag("penguin_small.jpg"),{ :controller => 'member', :action => 'journal', :id => u}}</span>"
    end
    str << " "
    str << "#{link_to h(text), {:controller => 'member', :action => 'journal', :id => u}, :class => cls}"     
  end

  def link_to_user_image(u, cls)
    if u.mugshot
      "#{link_to image_tag(u.mugshot.public_filename, :size => '100x100', :alt => u.name, :title => u.name ),
        {:controller => 'member', :action => 'journal', :id => u}, :class => cls}"
    else
      "#{link_to b_image_tag("penguin.jpg", :size => '100x100', :alt => u.name, :title => u.name ),
        { :controller => 'member', :action => 'journal', :id => u}, :class => cls}"
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

  def link_to_diary(r, text, size=32, cls=nil)
    if size
      link_to format_content(truncate(text, :length => size)), {:controller => 'member', :action => 'show', :id => r}, cls
    else
      link_to format_content(text), {:controller => 'member', :action => 'show', :id => r}, cls
    end
  end

  def month_selected
    if params[:month]
      params[:month].to_i
    elsif params[:date]
      params[:date][:month].to_i
    else
      Time.now.month
    end
  end

  def year_selected
    if params[:year]
      params[:year].to_i
    elsif params[:date]
      params[:date][:year].to_i
    else
      Time.now.year
    end
  end

  def link_to_delete(con, id)
    link_to b_image_tag("delete.png",
                      :border => "0",
                      :mouseover => b_image_path("delete_over.gif")),
                      {:controller => con, :action => 'destroy', :id => id},
                      :confirm => '妳確定要刪除嗎?', :method => :post
  end

  def ajax_link_to_delete
    link_to b_image_tag("delete.png",
                      :border => "0")
  end

  def ck_box(item, opt, checked)
    checked = (checked == 1 || checked == true) ? true : false
    check_box_tag("item[#{item.id.to_s}][#{opt}]", 1, checked )
  end

  def goal_ck_box(id, opt, checked)
    checked = (checked == 1 || checked == true) ? true : false
    check_box_tag("item[#{id}][#{opt}]", 1, checked )
  end

  def text_fields(item, comment)
    text_field_tag "item["+item.id.to_s+"][comment]", comment
  end

  def rank_fields(item, rank)
    text_field_tag "item["+item.id.to_s+"][rank]", rank, :size => 3
  end

  def state_image(done, img1='plus.gif', img2='minus.gif')
    #image = done ? b_image_tag(img1) : b_image_tag(img2)
    image = done ? "<span class='journal-img journal-todo-plug'></span>" : "<span class='journal-img journal-todo-min'></span>"
  end

  HTTP_REGEX = /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/[A-Za-z\.0-9_\+\?%\/=&\-]*)?)/ix

#  def format_content(content)
#    c = content
#    return '' if c.blank?
#
#    return c.gsub(/\r\n/, "\n").gsub(/\n/) { |e|
#      "<br />" unless $` =~/<br \/>$/
#    } 
#  end


  def full_format_content(content)
    c = content
    return '' if c.blank?

    return c.gsub(/\r\n/, "\n").gsub(/\n/) { |e|
      "<br />" unless $` =~/<br \/>$/
    }.gsub(HTTP_REGEX) do  |e| 
      if $` =~/(href|src)=(?:"|')$/ 
        e
      else 
        "<a href='#{e}'>#{e}</a>"
      end
    end
  end

  alias_method :format_content, :full_format_content

  def need_accepter(user, call_id)
    if user
      "#{link_to_user(user, user.name)}"
    else
      link_to '我可以幫忙,', {:controller => 'calls', :action => 'update', :id => call_id},
                                :confirm => '妳確定要幫忙嗎?', :method => :post
    end
  end

  def link_to_cancel(col = "member", text = I18n.t('action.cancel'))
    link_to text, :controller => col, :action => 'journal'
  end

  def week_day(day)
    if [0, 6].include?(day)
      "<font color='red'>#{WEEK_DAYS[day]}</font>"
    else
      WEEK_DAYS[day]
    end
  end

  def link_to_group(text, id)
    link_to text, :controller => 'groups', :action => 'show', :id => id
  end

  def link_to_my_group
    if @me.group
      link_to @me.name+"#{t('member.group_title')}", :controller => 'groups', :action => 'show', :id => @me.group_id
    else
      "<span class='alert'>
      #{link_to '妳還沒有參加任何的早起團', :controller => 'groups', :action => 'index'}
      </span>"
    end
  end

  def big_mugshot(item, title=nil)
    if @big_mugshot = item.mugshot
      image_tag(@big_mugshot.public_filename, :title => title ||= item.name)
    else 
      b_image_tag("penguin.jpg", :title => title )
    end
  end

  def small_mugshot(item, title=nil)
    if @small_mugshot = item.mugshot
      image_tag(@small_mugshot.public_filename(:small), :title => title ||= item.name)
    else 
      b_image_tag("penguin_small.jpg", :title => title )
    end
  end

  def week_day(wday)
    WEEK_DAYS[wday]
  end

  def score_state(user, size='128')
    score = user.status.score
    score ||= 0
    SCORE_STATE.each_with_index do |a,i|
      if score > SCORE_STATE.at(i)
        files = Dir.entries("#{RAILS_ROOT}/public/images/score/#{i}")
#
        files.delete(".")
        files.delete("..")
#
        #name = files.at(rand(files.size))
        name = files.at(0)
        title = name.gsub(/_.*/,'')
#        type = name.gsub(/.*\./,'')
        return "<a class=sprite-#{title}_#{size} title=#{score}分></a>"
        #return b_image_tag("score/#{i}/#{title}_#{size}.#{type}", :title => "#{score}分")
      end
    end

  end

end
