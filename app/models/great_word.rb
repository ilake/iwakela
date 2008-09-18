class GreatWord < ActiveRecord::Base
  def self.find(*args)
    scope = args.first
    if scope.to_s == "random"
      super :first, :offset => (rand count).to_i
    elsif scope.to_s == "public"
      # blah, blah...
    else
      super
    end
  end
end
