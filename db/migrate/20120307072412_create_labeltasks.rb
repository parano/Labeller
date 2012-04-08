class CreateLabeltasks < ActiveRecord::Migration
  def change
    create_table :labeltasks do |t|
      t.string :status
      t.references :labeljob
      #t.text :rawdata, :limit => 4294967295
      t.integer :user_id
      t.integer :label_count
      t.integer :unlabel_count

      t.timestamps
    end
    add_index :labeltasks, [:labeljob_id, :user_id ]
  end
end
