# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def number_clock(record)
    str = record.todo_time.strftime('%H:%M')
    html =''
    str.each_char do |c|
      c = (c == ':') ? 'colon' : c
      html << (b_image_tag "numbers/#{c}.png", :size => '16x21')
    end
    html
  end

  def show_messages
    flh =  flash[:notice] || flash[:info]
    "<div class='bg-or pad-10 mar-b-10 w-black fw-bold center rounded'>#{flh}</div>"  if flh
  end

  def language_mobile_setting
    if cookies[:language] == '0'
      "#{link_to "简体版", :controller => 'main', :action => 'language', :type => 'simple'}
      #{link_to "手機版", :controller => 'mobile', :action => 'index'}"
    else
      "#{link_to "繁體版", :controller => 'main', :action => 'language', :type => 'tradition'}
      #{link_to "手机版", :controller => 'mobile', :action => 'index'}"
    end
  end

  def _back_image_path(source, back_host_const_name)
    if Object.const_defined?(back_host_const_name)
      host = Object.const_get(back_host_const_name)
      unless source =~ %r{^[-a-z]+://}
        source = "http://#{host}:#{request.port}/images/#{source}"
      end
    else
      image_path(source) 
    end
  end
  
  def b_image_path(source)
    _back_image_path(source, 'BACKOFFICE_IMAGE_HOST')
  end 
    
  def b_image_tag(source, options = {})
    image_tag(b_image_path(source), options)
  end  
end
