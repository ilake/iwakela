#require 'rubygems'
#require 'hpricot'
#require 'open-uri'
#
#url = "http://www.iwakela.com"
#
#doc = Hpricot(open(url))
#doc.search('table tr').each do |item|
#  (item/'a').each do |nav|
#    p nav.attributes['href']
#    p nav.inner_html
#  end
#end

require 'pathname'
#p = Pathname.new(File.dirname(__FILE__))

#p size = p.size              # 27662
#p isdir = p.directory?       # false
#p dir  = p.dirname           # Pathname:/usr/bin
#p base = p.basename          # Pathname:ruby
#p dir, base = p.split        # [Pathname:/usr/bin, Pathname:ruby]
#p data = p.read
#p.open { |f| _ }
#p.each_line { |line| _ }
p File.dirname(__FILE__)
p Dir.pwd
p File.read("#{Dir.pwd}")
