module AuthHelper
  def admin_area(&block)
    if @me && @me.id == ADMIN_ID
      concat content_tag(:div, capture(&block), :class => 'admin_area'), block.binding
    end
  end

  def is_owner?(user=nil)
    if user
      @is_owner ||= @me == user ? true : false
    elsif @me 
      @is_owner ||= @me == @user ? true : false
    else
      false
    end
  end

  def user_content_right(type)
     @user.setting.send(type) == 0 || (@user.setting.send(type) == 1 && is_owner?)
  end

end
