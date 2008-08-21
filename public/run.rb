require 'pp'
require 'benchmark'
require 'rubygems'
require 'xml/libxml'
require 'hpricot'
require 'rexml/document'

include Benchmark 

signal_keys = [:signal_type, :create_datetime, :realized_or_unrealized,
  :close_datetime, :open_price, :close_price, :performance,
  :annualized_performance]

$rsp1 = {}
$rsp2 = {}

bm(10) do |test|

  str = File.read('test.xml')

      test.report('libxml') do
      xml_doc = XML::Parser.string(str).parse
      root = xml_doc.root
      root.find('target').each do  |t|
      $rsp2[t.find_first('target_id').content] = rsp_target = {}
      rsp_target[:target_performance_average] = t.find_first('performance_average').content
      rsp_target[:target_annualized_performance_average] = t.find_first('annualized_performance_average').content
      
      t.find('signal').each do |signal|
        rsp_target[signal.find_first('signal_id').content.to_sym] = signal_keys.inject({}) do |h,k|
          h[k] = signal.find_first(k.to_s).content ; h 
        end
      end
    end

  end
  
  test.report('hpricot') do 
    xml_doc = Hpricot(File.open('test.xml'))
    (xml_doc/:target).each do |t|
      $rsp1[t.at(:target_id).innerHTML] = rsp_target = {}
      rsp_target[:target_performance_average] = t.at("performance_average").innerHTML
      rsp_target[:target_annualized_performance_average] = t.at("annualized_performance_average").innerHTML   
      (t/:signal).each do |signal|
        rsp_target[signal.at(:signal_id).innerHTML.to_sym] = signal_keys.inject({}) do |h,k|
          h[k]=signal.at(k).innerHTML  ; h
        end
      end
    end
  end
  
end
