class CreateAttendeeFields < ActiveRecord::Migration[5.2]
  def change
    create_table :attendee_fields do |t|
      t.string :name
      t.string :label
      t.string :kind
      t.text :options, array: true, default: []

      t.timestamps
    end
  end
end
