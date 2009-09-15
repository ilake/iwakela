class AddProfileDreamWord < ActiveRecord::Migration
  def self.up
    add_column :profiles, :dream_word, :text
  end

  def self.down
    remove_column :profiles, :dream_word
  end
end
