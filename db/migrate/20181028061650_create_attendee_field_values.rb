class CreateAttendeeFieldValues < ActiveRecord::Migration[5.2]
  def change
    create_table :attendee_field_values do |t|
      t.text :content
      t.references :attendee_field, foreign_key: true
      t.references :attendee, foreign_key: true

      t.timestamps
    end
  end
end
