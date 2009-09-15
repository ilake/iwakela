# == Schema Information
# Schema version: 20090809070358
#
# Table name: goals
#
#  id      :integer(4)      not null, primary key
#  user_id :integer(4)      
#  choosed :integer(4)      
#  done    :boolean(1)      
#  name    :string(255)     
#  comment :text            
#  rank    :integer(4)      default(0)
#  total   :integer(4)      default(0)
#

# status 0 是active, 1是完成刪, 2是放棄刪（可恢復）
class Goal < ActiveRecord::Base
  belongs_to :user
  has_many :goal_details, :dependent => :destroy

  validates_uniqueness_of :name, :scope => :user_id
  validates_presence_of :name
  
  named_scope :active, :conditions => {:status => 0}
  named_scope :complete, :conditions => {:status => 1}
  named_scope :giveup, :conditions => {:status => 2}
  named_scope :no_once, :conditions => "name <> 'once'"

  named_scope :by_rank, :order => 'rank'

  def change_goal_status(status=-1)
    case status
    when -1
      destroy
    when 0, 1, 2
      self.update_attributes(:status => status)
    else
      return false
    end
  end
end
