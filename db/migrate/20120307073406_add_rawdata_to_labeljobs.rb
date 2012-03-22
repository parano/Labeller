class AddRawdataToLabeljobs < ActiveRecord::Migration
  def change
    add_column :labeljobs, :rawdata, :string
    add_column :labeljobs, :filter,  :string
  end
end
