# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'
#ENV['HOME'] = '/home/iwakela' if ENV['RAILS_ENV'] == 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

#FOR HOSTING RAILS
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
  
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_earlybirds_session',
    :secret      => 'c3bc5b3ed1b4a3f6b26fd2c99162909266fd3f9fd03148897b1aef09c315be58717ff0f1fc59abd1185fdf81bb13e15f693722e28c8c788fd6f9243ca22ca341'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector


  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  #config.action_mailer.delivery_method = :smtp
  #config.action_mailer.delivery_method = :activerecord

  #config.gem "adzap-ar_mailer", :lib => 'action_mailer/ar_mailer', :source => 'http://gems.github.com'
  #config.gem "RMagick"
  config.gem 'hoptoad_notifier'
end
require 'json'
require "errors"

#require 'smtp_tls'
#ActionMailer::Base.delivery_method = :smtp 
#
#ActionMailer::Base.smtp_settings = {
#  :enable_starttls_auto => true,
#  :address => "smtp.gmail.com",
#  :port => "587",
#  :domain => "localhost.localdomain",
#  :authentication => :plain,
#  :user_name => "lake.ilakela@gmail.com",
#  :password => "poiuytr4321",
#}

ENV['TZ'] = 'Asia/Taipei'

def log_to(stream)
  ActiveRecord::Base.logger = Logger.new(stream)
  ActiveRecord::Base.clear_active_connections!
end

LOCALES_DIRECTORY = "#{RAILS_ROOT}/config/locales"
LOCALES_AVAILABLE = Dir["#{LOCALES_DIRECTORY}/*.{rb,yml}"].collect do |locale_file|
      I18n.load_path << locale_file
            File.basename(File.basename(locale_file, ".rb"), ".yml")
end.uniq.sort.reverse
