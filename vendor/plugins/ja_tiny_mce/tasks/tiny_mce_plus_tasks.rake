namespace :ja_tiny_mce do
  desc 'Install the ja_tiny_mce plugin'
  task :install do
    puts "** Installing ja_tiny_mce plugin ..."           

    source = File.join(RAILS_ROOT, '/vendor/plugins/ja_tiny_mce/assets/.')
    dest = RAILS_ROOT
    FileUtils.cp_r source, dest
         
    puts "** Successfully installed ja_tiny_mce plugin"
  end
  
  desc 'Install the ja_tiny_mce dependent plugins'
  task :plugins do
    puts "** Installing ja_tiny_mce dependent plugins ..."           

    source = File.join(RAILS_ROOT, '/vendor/plugins/ja_tiny_mce/plugins/.')
    dest = File.join(RAILS_ROOT, '/vendor/plugins/')
    FileUtils.cp_r source, dest
         
    puts "** Successfully installed ja_tiny_mce dependent plugins"
  end
end
