class CreateAttendeeWaivers < ActiveRecord::Migration[5.2]
  def change
    create_table :attendee_waivers, id: :uuid do |t|
      t.string :access_token
      t.belongs_to :waiver, foreign_key: true, type: :uuid
      t.belongs_to :attendee, foreign_key: true

      t.timestamps
    end
  end
end
