class AttendeeFieldValue < ApplicationRecord
  belongs_to :attendee_field
  belongs_to :attendee
end
