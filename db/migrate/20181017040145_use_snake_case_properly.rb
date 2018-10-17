class UseSnakeCaseProperly < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :startDate, :start_date
    rename_column :events, :endDate, :end_date
    rename_column :attendees, :fname, :first_name
    rename_column :attendees, :lname, :last_name
  end
end
