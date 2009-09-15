module MemberHelper

  def todo_table(record)
      unless record.success #早起
        tr = "<tr class = target_fail>"
      else #晚起
        tr = "<tr>"
      end
        tr + "<td class='todo_time'>
              #{exact_datetime_string(record.todo_time)}(#{WEEK_DAYS[record.todo_time.wday]})
              </td>
              <td class='diary'>#{link_to_diary(record, record.content) }</td>
              <td class='goal'>#{record.com_goal}</td>
              <td class='rsp'>#{record.comments.size}</td>
              <td>#{link_to_remote b_image_tag("todo.png",
                                      :border => "0",
                                      :mouseover => b_image_path("todo_over.png")),
                                      :update => 'remote',
                                      :url => {:controller => 'goals', :action => 'create', :id => record.id}
                                      }</td>
              <td>#{link_to_remote b_image_tag("journal.png",
                                      :border => "0",
                                      :mouseover => b_image_path("journal_over.png")),
                                      :update => 'remote',
                                      :url => {:action => 'write_diary', :id => record.id}
                                      }</td>
              <td>#{link_to_delete('member', record.id)}</td>
              </tr>"
  end

  def record_flag(state)
    if state == 1
      b_image_tag('flag_yellow.png', :title => '補上或修改的紀錄')
    else
      b_image_tag('flag_green.png', :title => '不是補上或修改的紀錄')
    end
  end

  def set_range_link(from, to)
      link_to_remote "<h3 class='border_padding'>
      #{extract_date_string(from)} － #{extract_date_string(to)}
      #{b_image_tag('button_n_arrow_down.gif')}</h3>", :url => {:action => 'set_graph_range', :id => @user }
  end

  def journal_link(record, user)
    time = record.todo_time if record
    if record.blank?
      link_to '還沒有日誌喔', journal_url(:id => user)
    elsif record.todo_name == 'wake_up'
      link_to record.todo_time.to_s(:ymd), journal_url(:id => user, :year => time.year, :month => time.month, :day => time.day )
    elsif record.todo_name == 'sleep'
      link_to record.todo_time.to_s(:ymd), night_journal_url(:id => user, :year => time.year, :month => time.month, :day => time.day )
    end
  end

  def journal_date_link( state, content, url_hash, options)
    if state == 'daylight'
       link_to content, journal_url(url_hash), options 
    else
       link_to content, night_journal_url(url_hash), options
    end
  end

  def goal_journal_link(gd, user)
    if record = gd.record 
      time = gd.record.todo_time
      if gd.record.todo_name == 'wake_up'
        link_to gd.created_at.to_s(:ymd), journal_url(:id => user, :year => time.year, :month => time.month, :day => time.day)
      else
        link_to gd.created_at.to_s(:ymd), night_journal_url(:id => user,  :year => time.year, :month => time.month, :day => time.day)
      end
    else
      gd.created_at.to_s(:ymd)
    end
  end
end
