class AddSlugToAttendeeAndAttendeeFieldsAndWebhooks < ActiveRecord::Migration[5.2]
  def change
    add_column :attendees, :slug, :string
    add_column :attendee_fields, :slug, :string
    add_column :webhooks, :slug, :string
  end
end
