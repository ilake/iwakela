class Fighter
  #PRIME_VALUE = [541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601]
  PRIME_VALUE =  [601, 443, 389, 353, 359, 367, 373, 379, 397, 401, 409]
  #PRIME_VALUE = [443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 541]

  FIGHT_ATTRIBUTES = ['力量', '敏捷', '智力', '精神', '命中']

  attr_accessor :name, :hp, :attrs

  def initialize(name, game)
    @attr_value ||= create_attr_value(name, game)
    @name ||= name
    @hp ||= @attr_value.shift
    @attrs ||= @attr_value
  end

  private
  def create_attr_value(user_name, game)
    attr_value = []

    user_name ||= 'lala'
    attr_base = Fighter.encode(user_name, game.salt).unpack("CCCCCCC").join('').to_i
    count = game.attrs.count
    attr_names = game.attrs.all.map(&:name)
    attr_names.concat(FIGHT_ATTRIBUTES).uniq
    attr_names.unshift('hp')
    # 最少 6個屬性, 一個血, 一個其他
    attr_size = count < 5 ? 5 : count

    #{:name => '力量', :value => '40'}
    #第一個屬性 最少大於200 (當作血用)
    PRIME_VALUE.slice(0..attr_size).each_with_index do |p_value, i|
      val = (attr_base%p_value)
      if i == 0
        val = val < 350 ? val+350 : val
        #val = val * (attr_size/5)
      else
        val = val%100
      end

      att = {:name => attr_names[i], :value => val}

      attr_value << att
    end

    attr_value
  end

  def self.encode(name, salt)
    Digest::MD5.hexdigest(name + salt)
  end

end
