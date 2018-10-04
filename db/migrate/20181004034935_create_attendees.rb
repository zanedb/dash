class CreateAttendees < ActiveRecord::Migration[5.2]
  def change
    create_table :attendees do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.text :note
      t.json :extras
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
