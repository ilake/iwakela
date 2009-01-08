backup = "#{RAILS_ROOT}/log/#{RAILS_ENV}.log.template"
source = "#{RAILS_ROOT}/log/#{RAILS_ENV}.log"
`cp #{source} #{backup}; cat /dev/null > #{source}`
`gzip #{backup}`
`echo "iwakela production log" | mutt -a #{RAILS_ROOT}/log/production.log.template.gz -s 'iwakela production log' lake.ilakela@gmail.com`
`rm #{RAILS_ROOT}/log/production.log.template.gz`
