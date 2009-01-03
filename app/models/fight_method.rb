# == Schema Information
# Schema version: 20081227162431
#
# Table name: fight_methods
#
#  id         :integer(11)     not null, primary key
#  game_id    :integer(11)     
#  name       :string(255)     
#  fight_type :integer(11)     default(0)
#  value      :integer(11)     default(0)
#

class FightMethod < ActiveRecord::Base
  belongs_to :game

  validates_presence_of :name, :value
  validates_numericality_of :value, :less_than_or_equal_to => 200
  validates_numericality_of :value, :greater_than_or_equal_to => 0
  before_create :set_default_val

  def set_default_val
    self.value = self.value.zero? ? rand(150) : value
  end

  def self.find_or_create(params)
    unless self.find(:first, :conditions => ["name = ?", params[:name]])
      self.create(params)
    end
  end
end
