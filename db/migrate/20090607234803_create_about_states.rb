class CreateAboutStates < ActiveRecord::Migration
  def self.up
    create_table :about_states do |t|
      t.belongs_to :user
      t.string :confirm_email_code
      t.date :confirm_email_until
      t.boolean :confirm_email
    end

    User.all.each do |u|
      u.create_about_state unless u.about_state
    end
  end

  def self.down
    drop_table :about_states
  end
end
