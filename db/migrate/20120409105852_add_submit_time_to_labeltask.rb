class AddSubmitTimeToLabeltask < ActiveRecord::Migration
  def change
    add_column :labeltasks, :submit_time, :datetime
  end
end
