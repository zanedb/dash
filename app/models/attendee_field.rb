class AttendeeField < ApplicationRecord
  belongs_to :event
  has_many :values, class_name: 'AttendeeFieldValue', foreign_key: 'attendee_field_id'
end
