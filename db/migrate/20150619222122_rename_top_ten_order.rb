class RenameTopTenOrder < ActiveRecord::Migration
  def change
    rename_column :toptens, :order, :sort
  end
end
