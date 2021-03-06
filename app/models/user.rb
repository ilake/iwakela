# == Schema Information
# Schema version: 20090809070358
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
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
#  group_id                  :integer(4)      
#  group_nickname            :string(255)     
#  time_zone                 :string(255)     default("Taipei")
#  sleep_target_time         :datetime        
#

#!/usr/math/bin/ruby
class User < ActiveRecord::Base

  has_many :records, :dependent => :destroy
  has_many :targets, :dependent => :destroy
  has_many :chats, :dependent => :destroy
  has_many :goals, :dependent => :destroy
  has_many :forums, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :great_words, :dependent => :destroy
  has_many :service_profiles
  has_many :leave_messages, :class_name => 'Message', :foreign_key => :user_id
  has_many :own_messages, :class_name => 'Message', :foreign_key => :master_id, :conditions => {:message_id => nil}, :include => :reply
  has_many :own_messages_and_reply, :class_name => 'Message', :foreign_key => :master_id, :include => :reply

  #我發表過forum的comments
  #Its sql :
  #SELECT comments.* FROM comments INNER JOIN forums ON comments.record_id = forums.id AND comments.record_type = 'Forum' WHERE ((forums.user_id = 2))
  #example : u.forums.find(:all).map {|a| a.comments}  ===  u.forum_comments
  has_many :forum_comments, :through => :forums, :source => :comments  
  has_many :latest_record_comments, :through => :records, :source => :comments,:include => [:user, :record] , :order => "created_at DESC", :limit => 6
  has_many :record_comments, :through => :records, :source => :comments, :order => "created_at DESC"

  #forum 裡有我的 comments的 forum, 找出 forum array
  has_many :forums_has_comments,
           :through => :comments,
           :source  => :record,
           :source_type => 'Forum'

  #我在forum 裡所有的comments, 找出 comments array
  has_many :comments_in_forums,
           :foreign_key => :user_id,
           :class_name => 'Comment',
           :conditions => {:record_type => 'Forum'}

  has_many :demands, :foreign_key => 'demander_id', :class_name => 'Call'
  has_many :accepts, :foreign_key => 'accepter_id', :class_name => 'Call'
  has_many :tiny_mce_photos
  has_many :pushs

  has_one :own_group, :foreign_key => "owner_id", :class_name => 'Group'
  has_one :profile
  has_one :status
  has_one :mugshot
  has_one :setting
  has_one :about_state    #用來存email 是否認證


  belongs_to :group
  has_and_belongs_to_many :friends,
            :class_name => "User",
            :join_table => "friends",
            :association_foreign_key => "friend_id",
            :foreign_key => "user_id"

  has_and_belongs_to_many :be_friends,
            :class_name => "User",
            :join_table => "friends",
            :association_foreign_key => "user_id",
            :foreign_key => "friend_id"


  after_create :create_default_user_setting

  validates_presence_of     :name, :email
  validates_uniqueness_of   :name, :email
  validates_confirmation_of :password
  validates_length_of       :name, :within => 1..10

  validates_uniqueness_of   :email, :case_sensitive => false
  validate_on_create do |u|
    u.errors.add(:name, '暱稱不能有空白') if  u.name.match(/\s/)
  end


  attr_reader :password

  def validate
    errors.add_to_base("Wrong Email style") unless email =~ /^([_A-Za-z0-9-]+)(\.[_A-Za-z0-9-]+)*(\+[_A-Za-z0-9-]+)*@([a-z0-9-]+)(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
  end

  def target_time(time=nil)
    user_time = time ? time : Time.now.since(self.setting.time_offset.hours)
    if target = self.targets.wake.find_by_week(user_time.wday)
      target_time = target.todo_target_time
      Time.local(user_time.year.to_i, user_time.month.to_i, user_time.day.to_i, target_time.hour, target_time.min, 0)
    elsif target_time = self.target_time_now
      Time.local(user_time.year.to_i, user_time.month.to_i, user_time.day.to_i, target_time.hour, target_time.min, 0)
    end
  end

  def target_sleep_time(time=nil)
    user_time = time ? time : Time.now.since(self.setting.time_offset.hours)
    if target = self.targets.sleep.find_by_week(user_time.wday)
      target_time = target.todo_target_time
      Time.local(user_time.year.to_i, user_time.month.to_i, user_time.day.to_i, target_time.hour, target_time.min, 0)
    elsif target_time = self.sleep_target_time
      Time.local(user_time.year.to_i, user_time.month.to_i, user_time.day.to_i, target_time.hour, target_time.min, 0)
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
      if user && encode(h[:password], user.password_salt) == user.password_hash# && user.about_state.confirm_email
        user
      elsif user# && !user.about_state.confirm_email
        user.errors.add(:email, "no_confirm") 
        user
      end
  end

  def self.authenticate_by_cookie(cookie)
    return nil if cookie.blank?
    pass, id, hash  = cookie.split(':')
    user = find(id) 

    if user && encode(pass,user.password_salt) == hash
      user
    end
  end 

  def self.find_all_users(params, page_size=12)
    self.paginate :page => params,
                  :per_page => page_size,
                  :include => [:profile, :mugshot],
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

  def self.send_confirm_email(email)
    if user = self.find_by_email(email)
      user.about_state.confirm_email_until = 1.month.from_now
      user.about_state.confirm_email_code = self.random_str
      user.about_state.save!
      EbMail.deliver_confirm_email(user)
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

  def self.check_confirm_email_code(code)
    if state = AboutState.find_by_confirm_email_code(code)
      user = state.user
      if user && user.about_state.confirm_email_until && (Time.now < user.about_state.confirm_email_until)
        user.about_state.confirm_email = true
        user.about_state.save!
        user
      else
        nil
      end
    else
      nil
    end
  end

  def today_record
    record = self.records.wake.last(:order => 'todo_time')
    user = record.user if record
    if record && record.todo_time.at_beginning_of_day == Time.now.since(user.setting.time_offset.hours).at_beginning_of_day
      record
    else
      nil
    end
  end

  def today_sleep_record
    record = self.records.sleep.last(:order => 'todo_time')
    user = record.user if record
    if record && record.todo_time.at_beginning_of_day == Time.now.since(user.setting.time_offset.hours).at_beginning_of_day
      record
    else
      nil
    end
  end

  def self.find_fight_user_result(fight=true, state=0)
    self.find(:all, :include => :status, :conditions => ['statuses.fight = ? and statuses.state = ?', fight, state])
  end

  def self.find_group_user_result(state=0)
    self.find(:all, :include => [:mugshot], :joins => :status, :conditions => ['statuses.state = ?', state])
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
                  :include => [:status, :mugshot, :profile],
                  :order => order,
                  :conditions => ["statuses.num > ? AND statuses.last_record_created_at > ? AND users.target_time_now is not NULL", 7, Time.now.ago(3.days)]
  end

  def self.find_friends_rank(page, sort)
    sort ||= 'diff'
    if ["success_rate", "continuous_num"].include?(sort)
      order = "statuses.#{sort} DESC"
    else
      order = "statuses.#{sort}"
    end
    self.paginate :page => page,
                  :per_page => 10,
                  :include => [:status, :mugshot, :profile],
                  :order => order
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
    self.create_setting
    self.create_about_state
  end

  def self.today_earliest(result='success', num = 20)
    if result == 'success'
      #Record.wake.today.success.find(:all, :limit => num, :order => 'todo_time').map{|r|r.user}
      records = Record.wake.success.find(:all, :select => :user_id, :conditions => ["records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"], :limit => num, :order => 'todo_time')


    else
      records = Record.wake.fail.find(:all, :select => :user_id, :conditions => ["records.todo_time > '#{Time.now.at_beginning_of_day.to_s(:db)}' AND records.todo_time < '#{Time.now.tomorrow.midnight.to_s(:db)}'"], :limit => num, :order => 'id DESC')
    end

      User.find(:all, :conditions => {:id => records.map{|r|r.user_id}}, :include => :mugshot)
  end

  def count_score(cond=nil)
    a = self.records.wake.find(:all, :order => "id DESC", :conditions => cond).map(&:success)
    cont_count = status.continuous_num

    total_score = Record.count_total_score(a, cont_count)
  end

  def see_msg_right(message, me)
    message.public == 0 || self == me || message.user == me || (message.parent_msg && message.parent_msg.user == me)
  end

  def see_journal_right(record, me)
    record.pri == 0 || self == me
  end

  def own_right(me)
    self == me
  end

  def time_now
    Time.now.since(self.setting.time_offset.hours)
  end

  private 
  def self.random_str
    Digest::SHA1.hexdigest(rand(0xffffffff).to_s)
    #[Array.new(6){rand(256).chr}.join].pack("m").chomp.delete('\\')
  end

  def self.encode(content, salt)
    Digest::MD5.hexdigest(content + salt)
  end

end
#has_many :scores
#
#  field = Profile.content_columns.inject([]) do |result, column|
#    result << column.name
#  end.push(:to => :profile)
#
#  delegate *field
#
#  setting = Setting.content_columns.inject([]) do |result, column|
#    result << column.name
#  end.push(:to => :setting)
#
#  delegate *setting
#
#  status = Status.content_columns.inject([]) do |result, column|
#    result << column.name
#  end.push(:to => :status)
#
#  delegate *status
#
#  about_state = AboutState.content_columns.inject([]) do |result, column|
#    result << column.name
#  end.push(:to => :about_state)
#
#  delegate *about_state

