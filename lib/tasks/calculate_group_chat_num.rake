desc 'count group chat num'
namespace :cal do
  task :group_chat_num => :environment do
    Group.all.each do |group|
      group.chats_num = group.chats.count(:all, :conditions => {:created_at => Time.now.ago(7.days)..Time.now})
      group.members_count = group.members.count
      group.save!
    end
  end
end
