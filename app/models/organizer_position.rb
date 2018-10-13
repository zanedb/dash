class OrganizerPosition < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user, uniqueness: { scope: :event }

  has_one :organizer_position_invite
end
