class AddExportationToLabeljob < ActiveRecord::Migration
  def change
    add_column :labeljobs, :exportation, :text
  end
end
