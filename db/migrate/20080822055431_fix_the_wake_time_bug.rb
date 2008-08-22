class FixTheWakeTimeBug < ActiveRecord::Migration
  def self.up
    User.find(:all, :conditions => {:id => 2}).each do |u|
      u.records.each do |r|
        if r.todo_time < "20080603".to_time.to_s(:db)
          if r.todo_target_time
            r.update_attributes(:todo_time => 8.hours.since(r.todo_time), :todo_target_time => 8.hours.since(r.todo_target_time))
          else
            r.update_attribute(:todo_time, 8.hours.since(r.todo_time))
          end
        end
      end
    end

#    Record.find(:all).each do |r|
#      if r.todo_target_time
#        r.update_attributes(:todo_time => 8.hours.since(r.todo_time), :todo_target_time => 8.hours.since(r.todo_target_time))
#      else
#        r.update_attribute(:todo_time, 8.hours.since(r.todo_time))
#      end
#    end
#
#    User.find(:all).each do |u|
#      if u.target_time_now
#        u.update_attribute(:target_time_now, 8.hours.since(u.target_time_now))
#      end
#
#      if u.status.average
#        u.status.update_attribute(:average, 8.hours.since(u.status.average))
#      end
#
#      if u.status.last_record_created_at
#        u.status.update_attribute(:last_record_created_at, 8.hours.since(u.status.last_record_created_at))
#      end
#
#      if u.status.group_join_date
#        u.status.update_attribute(:group_join_date, 8.hours.since(u.status.group_join_date))
#      end
#    end
  end

  def self.down
  end
end
