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
      "#{CGI::escape k}"
    }.join('|')

    data_values.push(data_values[0])
    data_str  = data_values.join(',')
    outer_str = ([100] * data_values.size).join(',')
    title = "#{CGI::escape game_name}: #{CGI::escape fighter_name}"

    str =<<-API
    <img src='http://chart.apis.google.com/chart?chs=250x250&cht=r&chd=t:#{data_str}|#{outer_str}&chl=#{names_str}&chm=B,FF000070,0,2,10&chtt=#{title}'></img>
    API
  end

  def round_desc(round)
    "[#{round.fighter1}] 對 [<span class='beated'>#{round.fighter2}</span>] 使出 #{round.atk_method}, 傷害#{round.atk_val} | <span class='round_hp1'>#{round.hp1}</span> VS <span class='round_hp2'>#{round.hp2}</span>| <span class='round_hp1_percent'>#{round.hp1_percent}%</span> VS <span class='round_hp2_percent'>#{round.hp2_percent}%</span>"
  end
end

