class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :labeltask_id
      t.integer :line_number
      t.string :label
      t.text :rawdata

      t.timestamps
    end
    add_index :solutions, :labeltask_id
    add_index :solutions, :line_number
    add_index :solutions, [:labeltask_id, :line_number], :unique => true
  end
end
