# == Schema Information
# Schema version: 20090809070358
#
# Table name: talks
#
#  id         :integer(4)      not null, primary key
#  game_id    :integer(4)      
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
