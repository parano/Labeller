class AddChnlAndTpyeToLabeljob < ActiveRecord::Migration
  def change
    add_column :labeljobs, :chnl_name, :string

    add_column :labeljobs, :kw_type, :string

  end
end
