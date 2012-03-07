class CreateLabeljobs < ActiveRecord::Migration
  def change
    create_table :labeljobs do |t|
      t.string :name
      t.text :desc
      t.date :deadline
      t.string :labels

      t.timestamps
    end
  end
end
