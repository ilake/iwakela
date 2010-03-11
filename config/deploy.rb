set :application, 'iwakela'
#user for ssh login
#set :user, 'iwakela0'
#set :domain, 'iwakela.com'
set :user, 'root'
set :domain, 'fb.iwakela.com'

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
#set :deploy_to, "/home/#{user}/deploy"
set :deploy_to, "/var/rails/eb_deploy"

set :shared_children, %w(system log pids mugshots tiny_mce_photos)

after 'deploy:symlink',  'iwakela:extra_setting'

role :web, domain
role :app, domain
role :db,  domain, :primary => true


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

  task :update do 
    deploy::update
  end

  task :rebuild_asset do
    run "cd #{latest_release} && rake asset:packager:build_all;"
  end

  task :start do 
    deploy::migrate
    rebuild_asset
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
