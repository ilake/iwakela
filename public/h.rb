require 'rubygems'
require 'hpricot'
require 'open-uri'

url = "http://www.iwakela.com"

doc = Hpricot(open(url))
doc.search('table tr').each do |item|
  (item/'a').each do |nav|
    p nav.attributes['href']
    p nav.inner_html
  end
end
