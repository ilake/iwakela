# == Schema Information
# Schema version: 20090809070358
#
# Table name: attrs
#
#  id      :integer(4)      not null, primary key
#  game_id :integer(4)      
#  name    :string(255)     
#

class Attr < ActiveRecord::Base
  HUMANIZED_ATTRIBUTES = {
    :name => "名稱",
    :desc => "描述"
  }

  belongs_to :game
  validates_length_of :name, :within => 1..5, :too_long => "太長啦, 取短一點", :too_short => "太短啦, 取長一點"

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def self.find_or_create(params)
    unless self.find(:first, :conditions => ["name = ?", params[:name]]) || self.count > 7
      self.create(params)
    end
  end
end
