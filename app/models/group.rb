# == Schema Information
# Schema version: 20081227162431
#
# Table name: groups
#
#  id            :integer(11)     not null, primary key
#  name          :string(255)     
#  board         :text            
#  condition     :text            
#  user_num      :integer(11)     
#  state         :integer(11)     default(0)
#  created_at    :datetime        
#  owner_id      :integer(11)     
#  chats_num     :integer(11)     default(0)
#  members_count :integer(11)     
#

class Group < ActiveRecord::Base
  HUMANIZED_ATTRIBUTES = {
    :name => "團名",
    :condition => "條件",
    :user_num => "團員數"
  }
  has_many :members, :foreign_key => "group_id", :class_name => "User", :dependent => :nullify
  belongs_to :owner,  :foreign_key => "owner_id", :class_name => "User"

  has_many :chats, :dependent => :delete_all
  has_many :forums, :dependent => :delete_all

  has_one :mugshot

  named_scope :public, :conditions =>"state = 0 or state = 2"
  named_scope :private, :conditions =>"state = 1 or state = 3"

  validates_length_of :name, :within => 1..10
  validates_length_of :condition, :within => 1..300
  validates_numericality_of :user_num, :only_integer => true
  validates_inclusion_of :user_num, :in => 1..30

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

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

  def self.group_chats_num_reset
    Group.update_all(:chats_num=> 0)
  end

  def get_in?(user)
    !(self.state == 2 || self.state == 3 || self.members.size >= self.user_num || user.group)
  end

  def pri
    if state == 1 || state == 3
      @pri ||= 1
    else
      @pri ||= 0
    end
  end

  def fill
    if state == 2 || state == 3 || members.count == user_num
      @fill ||= 1
    else
      @fill ||= 0
    end
  end

  def self.find_group_rank(page, sort='id')
    order = "groups.#{sort} DESC"
    self.paginate :page => page,
                  :per_page => 10,
                  :include => :mugshot,
                  :order => order
  end

  def self.find_all_group(page, sort='id', per_page=5)
    order = "groups.#{sort} DESC"

    self.paginate :page => page,
                  :per_page => per_page,
                  :include =>  [:mugshot, :owner],
                  :order => order
  end

  def self.count_7_days_chats_num
    all.each do |group|
      group.chats_num = group.chats.count(:all, :conditions => {:created_at => Time.now.ago(7.days)..Time.now})
      group.save!
    end
  end
end
