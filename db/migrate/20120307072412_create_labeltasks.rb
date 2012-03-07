class CreateLabeltasks < ActiveRecord::Migration
  def change
    create_table :labeltasks do |t|
      t.integer :status
      t.references :labeljob
      t.text :rawdata

      t.timestamps
    end
    add_index :labeltasks, :labeljob_id
  end
end
