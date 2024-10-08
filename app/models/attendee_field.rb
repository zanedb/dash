# frozen_string_literal: true

class AttendeeField < ApplicationRecord
  extend FriendlyId

  belongs_to :event, touch: true
  has_many :values,
           class_name: 'AttendeeFieldValue',
           foreign_key: 'attendee_field_id',
           dependent: :destroy

  enum kinds: %i[text multiline email checkbox multiselect]

  validates_presence_of :name, :label, :kind
  validates :name, uniqueness: {
    scope: :event,
    message: 'must be unique'
  }
  validates :name, format: {
    without: /\s/,
    message: 'cannot contain spaces'
  }

  friendly_id :slug_candidates, use: :scoped, scope: :event
  def slug_candidates
    [
      :name,
      %i[name kind]
    ]
  end

  after_create :create_values

  def value_for(attendee)
    AttendeeFieldValue.where(attendee: attendee, field: self).first
  end

  protected

  def create_values
    event.attendees.each do |attendee|
      attendee.values.create(field: self, content: '')
    end
  end
end
