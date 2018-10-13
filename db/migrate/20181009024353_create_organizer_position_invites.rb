# frozen_string_literal: true

class CreateOrganizerPositionInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :organizer_position_invites do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.references :organizer_position, foreign_key: true
      t.references :sender, foreign_key: { to_table: :users }

      t.text :email

      t.datetime :accepted_at
      t.datetime :rejected_at

      t.timestamps
    end

    # This is to ensure that events cannot have multiple events out to the
    # same email / user at the same time.
    add_index :organizer_position_invites, %i[event_id email user_id],
              unique: true,
              name: 'index_organizer_position_invites_uniqueness'
  end
end
