class AddCheckedInDataToHardwareItems < ActiveRecord::Migration[5.2]
  def change
    add_column :hardware_items, :checked_in_at, :datetime
    add_reference :hardware_items, :checked_in_by, foreign_key: { to_table: :users }
  end
end
