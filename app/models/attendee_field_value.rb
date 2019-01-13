class AttendeeFieldValue < ApplicationRecord
  belongs_to :attendee, foreign_key: 'attendee_id', touch: true
  belongs_to :field, foreign_key: 'attendee_field_id', class_name: 'AttendeeField', touch: true
end
