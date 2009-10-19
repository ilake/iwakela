namespace :cal do 
  desc 'step1: calculate attendance'
  task :attendance => :environment do 
    now = Time.now
    Group.find(:all).each do |g|
        g.members.find(:all).each do |m|
        total_join_days = ((now.at_beginning_of_day - m.status.group_join_date)/86400).ceil
        total_join_days = 1 if total_join_days.zero?
        record_nums =  m.records.wake.count(:all, :conditions => ['todo_time > ? ', m.status.group_join_date.tomorrow])
        attendance = record_nums/total_join_days.to_f
        m.status.update_attribute(:attendance, attendance*100)
      end
    end
  end

  desc 'step2: count group chat num'
  task :group_chat_num => :attendance  do
    Group.all.each do |group|
      group.chats_num = group.chats.count(:all, :conditions => {:created_at => Time.now.ago(7.days)..Time.now})
      group.members_count = group.members.count
      group.save!
    end
  end

  desc 'step3: calculate performance'
  task :performance => :group_chat_num do 
    #state 4 是太久沒來的, 每天在reset_all_state rake 裡做更新
    #只是缺席或請假的才算, 今天有來(state 1 or 2)的也不算
    User.find(:all, :include => :status, :conditions => ["statuses.state <> ? AND statuses.state <> ? AND statuses.state <> ?", 1, 2, 4]).each do |user|
      status  = user.status

      #下面算績效的統一做
      #平均雖然也是績效之一  可是沒來的不知道要怎樣算, 所以搬回record 存 wake_up的時候算
      #user.records.set_average(status)
      user.records.set_successful_rate(status, user)
      user.records.set_continuous_num(status, user)

      #搬回record 存時算     
      #user.records.set_records_num(status)
      #user.records.set_last_record_time(status)
      #user.records.set_diff_time(status)
      user.records.set_score(status, user)
    end
  end

  desc 'step4: reset_all_state'
  task :reset_state => :performance do
    #最近一星期 fight 設成false, state 設成4
    #今天有來(state = 1 or 2)
    #反正只是缺席或請假的才算
    User.find(:all, :include => :status, :conditions => ["statuses.state <> ? AND statuses.state <> ? AND statuses.state <> ?", 1, 2, 4]).each do |u|
      if u.status.last_record_created_at 
        if u.status.last_record_created_at > Time.now.ago(1.week)
          u.status.update_attribute(:fight, true)
        else
          u.status.update_attribute(:fight, false)
          u.status.update_attribute(:state, 4)
        end
      else
        #因為有可能很多一次都沒紀錄的, 只要每天檢查有沒紀錄的state 就先設成4 
        #只要他有做紀錄就會state 變成1 or 2, fight也會變成true
        u.status.update_attribute(:fight, false)
        u.status.update_attribute(:state, 4)
      end
    end

    #因為fight false 也有可能是請假的
    Status.update_all("state = 0", "fight = true")
    Status.update_all("state = 3", "fight = false && state <> 4")
    Game.update_all("today_num = 0")
  end

  desc 'daily_jobs'
  task :daily_jobs => :reset_state do
    #EbMail.deliver_weekly_report(User.find(2)) 
  end

  desc 'use mail to test cron'
  task :test_cron => :environment do
    EbMail.deliver_weekly_report(User.find(2)) 
  end
end
