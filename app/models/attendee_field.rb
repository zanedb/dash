class AttendeeField < ApplicationRecord
  belongs_to :event
  has_many :attendee_field_values, through: :attendees, dependent: :destroy
end
