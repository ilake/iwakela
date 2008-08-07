# == Schema Information
# Schema version: 20
#
# Table name: groups
#
#  id         :integer(11)     not null, primary key
#  name       :string(255)     
#  board      :text            
#  condition  :text            
#  user_num   :integer(11)     
#  state      :integer(11)     default(0)
#  created_at :datetime        
#  owner_id   :integer(11)     
#
#state 0 public unfill
#state 1 private unfill
#state 2 public fill
#state 3 private fill

class Group < ActiveRecord::Base
  has_many :members, :foreign_key => "group_id", :class_name => "User", :dependent => :nullify
  belongs_to :owner,  :foreign_key => "owner_id", :class_name => "User"

  has_many :chats, :dependent => :delete_all
  has_many :forums, :dependent => :delete_all

  validates_length_of :name, :within => 1..10
  validates_length_of :condition, :within => 1..300
  validates_numericality_of :user_num, :only_integer => true
  validates_inclusion_of :user_num, :in => 1..30

  def self.count_all_group_user_attendance
    now = Time.now
    self.find(:all).each do |g|
        g.members.find(:all).each do |m|
        total_join_days = ((now.at_beginning_of_day - m.status.group_join_date)/86400).to_i
        total_join_days = 1 if total_join_days.zero?
        record_nums =  m.records.wake.count(:all, :conditions => ['todo_time > ? ', m.status.group_join_date.tomorrow])
        attendance = record_nums/total_join_days.to_f
        m.status.update_attribute(:attendance, attendance*100)
      end
    end
  end

  def get_in?(user)
    !(self.state == 2 || self.state == 3 || self.members.size >= self.user_num || user.group)
  end

  def pri
    if state == 1 || state == 3
      1
    else
      0
    end
  end

  def fill
    if state == 2 || state == 3
      1
    else
      0
    end
  end

end
