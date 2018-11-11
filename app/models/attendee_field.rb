class AttendeeField < ApplicationRecord
  belongs_to :event
  has_many :values, class_name: 'AttendeeFieldValue', foreign_key: 'attendee_field_id'

  KINDS = %i[text multiline checkbox]

  def value_for(attendee)
    AttendeeFieldValue.where(attendee: attendee, field: self).first
  end
end
