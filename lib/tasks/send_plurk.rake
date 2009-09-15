desc 'sending plurk'
task :send_plurk => :environment do
  include ActionController::UrlWriter
  begin
    s = ServiceProfile.find(ENV['SERVICE_ID'])
    record = Record.find(ENV['RECORD_ID'])
    username = s.name
    password = s.password
    plurk ||= Plurk::Base.new(username,password)
    plurk.login 
    if record.todo_name == 'wake_up'
      time = record.todo_time
      plurk.add_plurk("#{journal_url(:host => EB_HOST, :id => s.user, :year => time.year, :month => time.month, :day => time.day  )} (#{record.title})")
    else
      plurk.add_plurk("#{night_journal_url(:host => EB_HOST, :id => s.user, :year => time.year, :month => time.month, :day => time.day )} (#{record.title})")
    end
  rescue
    Rails.logger.debug "PLURK_ERROR: #{self.to_yaml}"
  end
end
