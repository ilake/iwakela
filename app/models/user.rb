# == Schema Information
# Schema version: 20
#
# Table name: users
#
#  id                        :integer(11)     not null, primary key
#  name                      :string(255)     
#  password_salt             :string(255)     
#  password_hash             :string(255)     
#  email                     :string(255)     
#  created_at                :datetime        
#  cookie_hash               :string(255)     
#  target_time_now           :datetime        
#  reset_password_code       :string(255)     
#  reset_password_code_until :datetime        
#  yahoo_userhash            :string(255)     
#  group_id                  :integer(11)     
#  group_nickname            :string(255)     
#

#!/usr/math/bin/ruby
class User < ActiveRecord::Base

  has_many :records
  has_many :targets
  has_many :chats
  has_many :goals
  has_many :forums
  has_many :comments

  #我發表過forum的comments
  #Its sql :
  #SELECT comments.* FROM comments INNER JOIN forums ON comments.record_id = forums.id AND comments.record_type = 'Forum' WHERE ((forums.user_id = 2))
  #example : u.forums.find(:all).map {|a| a.comments}  ===  u.forum_comments
  has_many :forum_comments, :through => :forums, :source => :comments  
  has_many :demands, :foreign_key => 'demander_id', :class_name => 'Call'
  has_many :accepts, :foreign_key => 'accepter_id', :class_name => 'Call'

  has_one :own_group, :foreign_key => "owner_id", :class_name => 'Group'
  has_one :profile
  has_one :status
  has_one :mugshot

  belongs_to :group

  after_create :create_default_user_setting

  validates_presence_of     :name, :email
  validates_uniqueness_of   :name, :email
  validates_confirmation_of :password
  validates_length_of       :name, :within => 1..10

  validates_uniqueness_of   :email, :case_sensitive => false

  #acts_as_ferret :fields => [:name]

  attr_reader :password

  def validate
    errors.add_to_base("Wrong Email style") unless email =~ /^([_a-z0-9-]+)(\.[_a-z0-9-]+)*(\+[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
  end

  def target_time(time=Time.now)
    if target = self.targets.find_by_week(time.wday)
      target_time = target.todo_target_time
      Time.local(time.year.to_i, time.month.to_i, time.day.to_i, target_time.hour, target_time.min, 0)
    elsif target_time = self.target_time_now
      Time.local(time.year.to_i, time.month.to_i, time.day.to_i, target_time.hour, target_time.min, 0)
    end
  end

  def password=(pass)
    @password = pass #used by confirmation validator
    salt = User.random_str

    self.password_salt = salt
    self.password_hash = User.encode(pass, salt)
  end

  def gen_cookie
    pass = User.random_str
    hash = User.encode(pass, password_salt)
    
    { :value => [pass, id, hash].join(':'), :expires => 30.days.from_now }
  end

  def edit_password(h_current, h)
    if User.encode(h_current[:old_password], self.password_salt) == self.password_hash
      if ((h[:password] == h[:password_confirmation]) && !h[:password_confirmation].blank?)
        self.password = h[:password]
        self.save!
        self
      end
    end
  end

  def self.authenticate(h)
    user = find_by_email(h[:email])
    if user && encode(h[:password], user.password_salt) == user.password_hash
      user
    end
  end

  def self.authenticate_by_cookie(cookie)
    return nil if cookie.blank?
    pass, id, hash  = cookie.split(':')
    user = find_by_id(id) 

    if user && encode(pass,user.password_salt) == hash
      user
    end
  end 

  def self.find_all_users(params, page_size=12)
    self.paginate :page => params,
                  :per_page => page_size,
                  :include => 'profile',
                  :order => "users.id DESC"
  end

  def self.find_all_members(params)
    self.paginate :page => params,
                  :per_page => 10,
                  :include => :status,
                  :order => "statuses.group_join_date"  
  end

  def forget_password
    self.reset_password_code_until = 1.day.from_now
    self.reset_password_code = User.random_str
    self.save!
    EbMail.create_forgot_password(self)
  end

  def self.send_reset_email(email)
    if user = self.find_by_email(email)
      user.reset_password_code_until = 1.week.from_now
      user.reset_password_code = self.random_str
      user.save!
      EbMail.deliver_forgot_password(user)
      user
    end
  end

  def self.reset_password(uid, pwd, pwd_confirm)
    user = self.find(uid)
    if ((pwd == pwd_confirm) && !pwd_confirm.blank?)
      user.password = pwd
      if user.save
        user
      end
    end
  end

  def self.check_reset_code(code)
    user = self.find_by_reset_password_code(code)
    if user && user.reset_password_code_until && Time.now < user.reset_password_code_until
      user
    else
      nil
    end
  end

  def today_record
    record = self.records.last(:order => 'todo_time')
    if record && record.todo_time.at_beginning_of_day == Time.now.at_beginning_of_day
      record
    else
      nil
    end
  end

  def self.find_fight_user_result(fight=true, state=0)
    self.find(:all, :include => :status, :conditions => ['statuses.fight = ? and statuses.state = ?', fight, state])
  end

  def self.find_group_user_result(state=0)
    self.find(:all, :include => :status, :conditions => ['statuses.state = ?', state])
  end

  #最近一個禮拜有紀錄的
  def self.find_user_no_records
    self.find(:all).each do |u|
      if u.status.last_record_created_at 
        if u.status.last_record_created_at > Time.now.ago(7.days)
          u.status.update_attribute(:fight, true)
        else
          u.status.update_attribute(:fight, false)
        end
      else
        u.status.update_attribute(:fight, false)
      end
    end
  end

  #daily 
  def self.reset_all_state
    self.find(:all).each do |u|
      if u.status.fight
        u.status.update_attribute(:state, 0)
      else
        u.status.update_attribute(:state, 3)
      end
    end
  end

  def self.find_user_rank(page, sort)
    sort ||= 'diff'
    if ["success_rate", "continuous_num"].include?(sort)
      order = "statuses.#{sort} DESC"
    else
      order = "statuses.#{sort}"
    end
    self.paginate :page => page,
                  :per_page => 10,
                  :include => :status,
                  :order => order,
                  :conditions => ["statuses.num > ? AND statuses.last_record_created_at > ? AND users.target_time_now is not NULL", 7, Time.now.ago(3.days)]
  end

  def change_group(group, join=true)
    if join
      self.update_attribute(:group_id, group.id)
      self.status.update_attribute(:group_join_date, Time.now.at_beginning_of_day)
    else
      self.update_attribute(:group_id, nil)
      self.status.update_attribute(:group_join_date, nil)
    end
  end

  def create_default_user_setting
    self.create_profile
    self.create_status
  end

  private 
  def self.random_str
    [Array.new(6){rand(256).chr}.join].pack("m").chomp
  end

  def self.encode(content, salt)
    Digest::MD5.hexdigest(content + salt)
  end

end
