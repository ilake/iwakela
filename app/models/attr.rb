class Attr < ActiveRecord::Base
  belongs_to :game

  def self.find_or_create(params)
    unless self.find(:first, :conditions => ["name = ?", params[:name]]) || self.count > 10
      self.create(params)
    end
  end
end
