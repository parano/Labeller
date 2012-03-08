class AddRawdataToLabeljobs < ActiveRecord::Migration
  def change
    add_column :labeljobs, :rawdata, :string
  end
end
