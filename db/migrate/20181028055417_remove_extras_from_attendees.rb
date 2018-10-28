class RemoveExtrasFromAttendees < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendees, :extras, :json
  end
end
