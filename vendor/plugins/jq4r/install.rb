require 'ftools'

plugins_dir = File.expand_path(RAILS_ROOT+'/vendor/plugins')
jq4r_dir = File.join(plugins_dir, 'jq4r')

File.copy File.join(jq4r_dir, 'javascripts', 'jq4r.js'), File.join(RAILS_ROOT, 'public', 'javascripts', 'jq4r.js')

