class CreateLabeljobsUsers < ActiveRecord::Migration
  def change
    create_table :labeljobs_users, :id => false do |t|
      t.integer :labeljob_id
      t.integer :user_id
    end
    add_index :labeljobs_users, :labeljob_id
    add_index :labeljobs_users, :user_id
    add_index :labeljobs_users, [:labeljob_id, :user_id], :unique => true
  end
end
