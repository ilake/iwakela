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
              <td>#{link_to_remote image_tag("todo.png",
                                      :border => "0",
                                      :mouseover => image_path("todo_over.png")),
                                      :update => 'remote',
                                      :url => {:controller => 'goals', :action => 'create', :id => record.id}
                                      }</td>
              <td>#{link_to_remote image_tag("journal.png",
                                      :border => "0",
                                      :mouseover => image_path("journal_over.png")),
                                      :update => 'remote',
                                      :url => {:action => 'write_diary', :id => record.id}
                                      }</td>
              <td>#{link_to_delete('member', record.id)}</td>
              </tr>"
  end

  def record_flag(record)
    if record.todo_name == 'sleep'
      image_tag('sleep.png', :title => '睡覺時間')
    elsif record.state == 1
      image_tag('flag_yellow.png', :title => '補上或修改的紀錄')
    else
      image_tag('flag_green.png', :title => '不是補上或修改的紀錄')
    end
  end

  def set_range_link(from, to)
      link_to_remote "<h3 class='border_padding'>
      #{extract_date_string(from)} － #{extract_date_string(to)}
      #{image_tag('button_n_arrow_down.gif')}</h3>", :url => {:action => 'set_graph_range'}
  end
end
