module LoadConstant
  def self.do(file)
    y = YAML.load_file(file)[RAILS_ENV]
    y.each do |k,v|
      Object.const_set(k.upcase.to_sym, v)
    end
  end
end
