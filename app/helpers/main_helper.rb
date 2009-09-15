module MainHelper
  def setting_link(text, anchor)
    link_to text, user_url(:action => :edit, :anchor => anchor)
  end
end
