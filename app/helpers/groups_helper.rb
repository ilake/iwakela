module GroupsHelper

  def link_to_quit(group)
    if @me.own_group == group
      link_to t('group.owner_quit'), :action => 'transfer_choose'
    elsif @me.group == group
      link_to t('group.normal_quit'), :action => 'quit'
    end
  end

  def link_to_fire(group, user)
    if @me.own_group == group && @me != user
      link_to b_image_tag("delete.png",
                      :border => "0",
                      :mouseover => image_path("delete_over.gif")),
                      {:action => 'fire', :id => user.id},
                             :confirm => t('group.fire'), :method => :post
    end
  end

  def link_to_invite(group)
    if @me.own_group == group
      link_to t('group.invite'), :action => 'invite_who', :id => group.id
    end
  end

  def link_to_edit(group)
    if @me.own_group == group
      link_to t('group.setting'), :action => 'edit', :id => group.id
    end
  end

  def link_to_join(group)
    unless group_user?(group)
      link_to t('group.join'), :action => 'join', :id => group
    end 
  end

  def link_to_absence(group)
    if (@me.own_group == group || @me.group == group) && @me.status.fight
      link_to t('group.wabsence'),{ :action => 'absence', :id => group.id, :absence => '1'},
                          :confirm => t('group.confirm_absence'), :method => :post
    elsif (@me.own_group == group || @me.group == group) && !@me.status.fight
      link_to "<span class='alert_red'>#{t('group.cancel_absence')}</span>",{ :action => 'absence', :id => group.id}, :confirm => t('group.confirm_cancel'), :method => :post
    end
  end

  def link_to_rank(group)
    if @me.own_group == group || @me.group == group
      link_to '排行榜', :action => 'rank_list', :id => group.id
    end
  end

  def link_to_group_user(group)
    if @me.own_group == group
      link_to t("group.member_set"), :action => 'list', :id => group.id
    end
  end

  def link_to_destroy(group)
    if @me.own_group == group
      link_to t('group.destroy'), {:action => 'destroy', :id => group.id},
                             :confirm => t('group.confirm_destroy'), :method => :post
    end
  end

  def link_to_post(group)
    if @me.own_group == group || @me.group == group
      link_to t('group.post'), :controller => 'forums', :action => 'new', :id => group.id 
    end
  end

  def link_to_post(group)
    if @me.own_group == group || @me.group == group
      link_to t('group.post_area'), :controller => 'forums', :action => 'group_forum_list', :id => group.id
    end
  end

  def link_to_set_title(group, user)
    if @me.own_group == group
      link_to b_image_tag("pencil.png",
                      :border => "0",
                      :mouseover => image_path("pencil_over.png")),
                      :action => 'edit_member_title', :id => user.id
    end
  end

  def link_to_all_members(users)
    members = ""
    users.each do |m|
      members += "#{link_to_member(m, m.name)}&nbsp;&nbsp;&nbsp;"
    end 
    members
  end

  def link_to_member(user, text)
    if user.group_nickname
      text ||= user.name
      "<span class='black'>#{user.group_nickname}</span>#{link_to_user(user, text)} "
    else
      "#{link_to_user(user, text)} "
    end
  end

  def group_user?(group)
    if @me.group || group.state == 1
      true
    else
      false
    end
  end

  def group_type_title(type, sort)
    title = []
    if type == 'public' && sort == 'id'
      title << "最新早起團"
    elsif type == 'public' && sort == 'chats_num'
      title << "活躍早起團"
    elsif type == 'private' && sort == 'id'
      title << "最新私人團"
    elsif type == 'private' && sort == 'chats_num'
      title << "活躍私人團"
    end

    title << link_to("  <<更多", :action => 'list_all_groups', :type => type, :sort => sort)
    title.join("")
  end

  def group_status(group)
    title = []
    title << "<span class='alert'>#{t('group.pri')}</span>" if group.pri 
    title << "<span class='alert'>#{t('group.full')}</span>" if group.fill

    title.join("")
  end
end
