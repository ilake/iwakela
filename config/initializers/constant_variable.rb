constants = YAML.load_file(File.join(RAILS_ROOT, 'config','constant_variable.yml'))
constants.each do |key, value|
  Object.const_set(key.upcase, value)
end

#would output
#>> FEELINGS
#=> ["說", "高興", "好奇"]
#>> CATEGORIES
#=> {"chat"=>"談天說地", "study"=>"進修資訊", "info"=>"早起資訊"}
#>> CONFIRM_CATEGORY
#=> ["info", "study"]


