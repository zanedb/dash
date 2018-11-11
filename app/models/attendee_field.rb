class AttendeeField < ApplicationRecord
  belongs_to :event
  has_many :values,
    class_name: 'AttendeeFieldValue',
    foreign_key: 'attendee_field_id',
    dependent: :destroy

  validates_presence_of :name, :label, :kind
  validates :name, uniqueness: {
    scope: :event,
    message: 'must be unique'
  }
  validates :name, uniqueness: { 
    case_sensitive: false,
    message: 'must be lowercase'
  }
  validates :name, format: {
    without: /\s/,
    message: 'cannot contain spaces'
  }

  KINDS = %i[text multiline checkbox]

  def value_for(attendee)
    AttendeeFieldValue.where(attendee: attendee, field: self).first
  end
end
