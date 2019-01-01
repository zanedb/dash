class RenameLocationToCity < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :location, :city
  end
end
