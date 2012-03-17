class CreateLabeltasks < ActiveRecord::Migration
  def change
    create_table :labeltasks do |t|
      t.string :status
      t.references :labeljob
      t.text :rawdata
      t.integer :user_id

      t.timestamps
    end
    add_index :labeltasks, [:labeljob_id, :user_id ]
  end
end
