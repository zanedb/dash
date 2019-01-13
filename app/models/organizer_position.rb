class OrganizerPosition < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :event, touch: true

  validates :user, uniqueness: { scope: :event }

  has_one :organizer_position_invite, dependent: :destroy
end
