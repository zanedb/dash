class AddCheckinToAttendees < ActiveRecord::Migration[5.2]
  def change
    add_column :attendees, :checked_in_at, :datetime
    add_reference :attendees, :checked_in_by, foreign_key: { to_table: :users }
  end
end
