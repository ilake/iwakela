module NamepkHelper
  def attr_string(attrs)
    status = attrs.inject({}){|h,k| h[k[:name]] = k[:value]; h }
  end

  def pk_charts(fighter, game)
    args = attr_string(fighter.attrs)
    fighter_name = fighter.name
    game_name = game.name

    data_names  = args.keys
    data_values = data_names.map {|k| args[k] }

    tmp = []
    data_values.each_with_index { |v,i| 
      tmp << "t#{v},FF0000FF,0,#{i},15"
    }

    names_str =  data_names.map {|k|
      v = args[k]
      "#{k}"
    }.join('|')

    data_values.push(data_values[0])
    data_str  = data_values.join(',')
    outer_str = ([100] * data_values.size).join(',')
    title = "#{game_name}: #{fighter_name}"

    str =<<-API
    <img src='http://chart.apis.google.com/chart?chs=250x250&cht=r&chd=t:#{data_str}|#{outer_str}&chl=#{names_str}&chm=B,FF000070,0,2,10&chtt=#{title}'></img>
    API
  end
end

