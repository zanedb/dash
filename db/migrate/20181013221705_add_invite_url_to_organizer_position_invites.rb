class AddInviteUrlToOrganizerPositionInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :organizer_position_invites, :invite_url, :string
  end
end
