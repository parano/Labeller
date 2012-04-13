class AddConflictsToLabeljob < ActiveRecord::Migration
  def change
    add_column :labeljobs, :conflicts, :text

  end
end
