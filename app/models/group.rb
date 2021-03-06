# == Schema Information
# Schema version: 20090809070358
#
# Table name: groups
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)     
#  board         :text            
#  condition     :text            
#  user_num      :integer(4)      
#  state         :integer(4)      default(0)
#  created_at    :datetime        
#  owner_id      :integer(4)      
#  chats_num     :integer(4)      
#  members_count :integer(4)      
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
  #validates_inclusion_of :user_num, :in => 1..50

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def self.group_chats_num_reset
    Group.update_all(:chats_num=> 0)
  end

  def get_in?(user)
    !(self.state == 2 || self.state == 3 || self.members.size >= self.user_num || user.group)
  end

  def pri
    state == 1 || state == 3
  end

  def fill
    state == 2 || state == 3 || members_count == user_num
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
end
