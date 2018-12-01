class AddCheckedInDataToAttendees < ActiveRecord::Migration[5.2]
  def change
    add_column :attendees, :checked_out_at, :datetime
    add_reference :attendees, :checked_out_by, foreign_key: { to_table: :users }
  end
end
