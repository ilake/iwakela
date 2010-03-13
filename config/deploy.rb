#----------------------------------------
#
#Memo: install rmagick for attachment_fu to resize image
#sudo apt-get install imagemagick
#sudo apt-get install libmagick9-dev
#sudo gem install rmagick
#http://github.com/dalibor/ubuntu_ror_installation
#
#----------------------------------------
set :application, 'iwakela'
#user for ssh login
task :stage do 
  set :user, 'iwakela0'
  set :hosting, 'hostingrails'
  set :deploy_to, "/home/#{user}/deploy"
  role :web, 'iwakela.com'
  role :app, 'iwakela.com'
  role :db,  'iwakela.com', :primary => true
end

task :production do 
  set :user, 'root'
  set :hosting, 'webbynode'
  set :deploy_to, "/var/rails/eb_deploy"
  role :web, 'fb.iwakela.com'
  role :app, 'fb.iwakela.com'
  role :db, 'fb.iwakela.com', :primary => true
end

default_run_options[:pty] = true

set :repository,  "git@github.com:ilake/iwakela.git"
set :scm, "git"
set :git_account, 'ilake'
set :scm_passphrase, "plokmiju" #This is your custom users password

set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false

set :shared_children, %w(system log pids mugshots tiny_mce_photos)

after 'deploy:symlink',  'iwakela:extra_setting'

namespace :iwakela do 
  task :extra_setting do
    %w(tiny_mce_photos mugshots).each do |dir|
      run <<-CMD
      rm -rf #{latest_release}/public/#{dir} &&
      mkdir -p #{latest_release}/public &&
      ln -s #{shared_path}/#{dir} #{latest_release}/public/#{dir}
    CMD
    end

    db_config = "#{latest_release}/config/database.online.yml"
    run "cp #{db_config} #{latest_release}/config/database.yml;"
  end

  task :chown do
    run "cd #{latest_release} && chown www-data #{latest_release} -R;"
#    run "cd #{latest_release} && chown www-data #{latest_release}/config/environment.rb;"
#    run "cd #{latest_release} && chown www-data #{latest_release}/public -R;"
#    run "cd #{latest_release} && chown www-data #{latest_release}/tmp -R;"
  end

  task :update do 
    deploy::update
  end

  task :rebuild_asset do
    run "cd #{latest_release} && rake asset:packager:build_all;"
  end

  task :start do 
    deploy::migrate
    rebuild_asset
    chown if hosting == 'webbynode'
    restart
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :deploy_all do 
    update
    start
  end
end
