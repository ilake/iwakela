class FightMethod < ActiveRecord::Base
  belongs_to :game

  validates_numericality_of :value, :less_than_or_equal_to => 200
  before_create :set_default_val

  def set_default_val
    self.value = self.value.zero? ? rand(500) : value
  end

  def self.find_or_create(params)
    unless self.find(:first, :conditions => ["name = ?", params[:name]])
      self.create(params)
    end
  end
end
