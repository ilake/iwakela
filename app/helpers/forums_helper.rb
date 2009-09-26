module ForumsHelper
  def forum_status(f)
    if f.last_comment_time 
      b_image_tag("icon_new.gif") if f.last_comment_time > Time.now.ago(3.days)
    else
      b_image_tag("icon_new.gif") if f.created_at > Time.now.ago(3.days)
    end
  end
end
