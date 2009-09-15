desc 'calculate attendance'
namespace :cal do 
  task :attendance => :environment do 
    now = Time.now
    Group.find(:all).each do |g|
        g.members.find(:all).each do |m|
        total_join_days = ((now.at_beginning_of_day - m.status.group_join_date)/86400).to_i
        total_join_days = 1 if total_join_days.zero?
        record_nums =  m.records.wake.count(:all, :conditions => ['todo_time > ? ', m.status.group_join_date.tomorrow])
        attendance = record_nums/total_join_days.to_f
        m.status.update_attribute(:attendance, attendance*100)
      end
    end
  end
end
