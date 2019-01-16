class AddPublicIdToAttendees < ActiveRecord::Migration[5.2]
  def change
    add_column :attendees, :public_id, :integer
  end
end
