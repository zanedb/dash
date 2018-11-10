class AttendeeFieldValue < ApplicationRecord
  belongs_to :attendee, through: :attendee_field
end
