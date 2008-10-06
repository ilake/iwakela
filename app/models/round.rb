class Round 
  attr_reader :fighter1, :fighter2, :atk_method, :atk_val, :hp1, :hp2

  def initialize(fighter1, fighter2, atk_method, atk_val, hp1, hp2)
    @fighter1   = fighter1
    @fighter2   = fighter2
    @atk_method = atk_method
    @atk_val    = atk_val
    @hp1        = hp1
    @hp2        = hp2
  end
end
