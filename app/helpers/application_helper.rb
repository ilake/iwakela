# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def number_clock(record)
    str = record.todo_time.strftime('%H:%M')
    html =''
    str.each_char do |c|
      c = (c == ':') ? 'colon' : c
      html << (image_tag "numbers/#{c}.png", :size => '16x21')
    end
    html
  end

end
