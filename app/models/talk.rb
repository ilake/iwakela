# == Schema Information
# Schema version: 20081227162431
#
# Table name: talks
#
#  id         :integer(11)     not null, primary key
#  game_id    :integer(11)     
#  name       :string(255)     
#  content    :text            
#  created_at :datetime        
#

class Talk < ActiveRecord::Base
  belongs_to :game
  validates_presence_of :name, :content

  def self.paginator(params, per_page=20)
    self.paginate :page => params,
                  :per_page => per_page,
                  :order => 'created_at DESC'
  end
end
