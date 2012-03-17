class CreateLabeljobs < ActiveRecord::Migration
  def change
    create_table :labeljobs do |t|
      t.string :name
      t.text :desc
      t.date :deadline
      t.string :labels
      t.integer :user_id
      t.boolean :finished, :default => false

      t.timestamps
    end
    add_index :labeljobs, [:user_id, :created_at]
  end
end
