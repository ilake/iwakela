class Attr < ActiveRecord::Base
  belongs_to :game
  validates_length_of :name, :within => 1..5,  :too_long => "太長啦, 取短一點", :too_short => "太短啦, 取長一點"

  def self.find_or_create(params)
    unless self.find(:first, :conditions => ["name = ?", params[:name]]) || self.count > 7
      self.create(params)
    end
  end
end
