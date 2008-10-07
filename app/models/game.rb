class Game < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_length_of :name, :within => 1..10

  has_many :attrs  #角色屬性
  has_many :fight_methods  #可能使用的招式

  before_create :set_salt

  attr_accessor :name1, :name2

  def set_salt
    self.salt = Game.random_str
  end

  def fighter_round(fighter1, fighter2)
    attack_desc = []

    attr1 = fighter1.attrs.map{|h| h[:value]}
    attr2 = fighter2.attrs.map{|h| h[:value]}

    name1 = fighter1.name
    name2 = fighter2.name

    hp1 = fighter1.hp[:value]
    hp2 = fighter2.hp[:value]

    average_hit_1 = average_attr(attr1)
    average_hit_2 = average_attr(attr2)


    around = 0
    around_size = fighter1.attrs.size

    while (hp1 > 0 && hp2 > 0)
      index = around%around_size
      ['fighter_1', 'fighter_2'].each do |user|
        atk_method = fight_methods.rand

        if user == 'fighter_1'
          #打出的傷害
          #fighter 1 打 fighter 2
          atk = attack_val(average_hit_1, attr1[index], atk_method.value)
          hp2 = hp2 - atk 

          attack_desc << Round.new(name1, name2, atk_method.name, atk, hp1, hp2)

          break if hp2 < 0
        elsif user == 'fighter_2'
          #fighter 2 打 fighter 1
          atk = attack_val(average_hit_2, attr2[index], atk_method.value)
          hp1 = hp1 - atk 
          attack_desc << Round.new(name2, name1, atk_method.name, atk, hp1, hp2)

          break if hp1 < 0
        end

      end
    end

    attack_desc
  end

  private
  def self.random_str
    [Array.new(8){rand(256).chr}.join].pack("m").chomp
  end

  def average_attr(attrs)
    sum = attrs.sum
    size = attrs.size
    average = (sum-attrs[0])/(size-1)
  end

  def attack_val(average, attr_val, atk_method_val)
    attr_val = rand(attr_val)
    atk_method_val = rand(atk_method_val)
    attack_val = (average + attr_val + atk_method_val).to_i
  end

end