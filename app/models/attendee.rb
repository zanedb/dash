# frozen_string_literal: true

require 'csv'

class Attendee < ApplicationRecord
  include SearchCop

  search_scope :search do
    attributes %i[first_name last_name], :email
    # attributes :fields
  end

  default_scope { order(created_at: :desc) }

  scope :checked_in, -> { where.not(checked_in_at: nil) }
  scope :checked_in_and_out, -> { where.not(checked_in_at: nil, checked_out_at: nil) }

  belongs_to :event
  has_many :fields, through: :values, class_name: 'AttendeeField'
  has_many :values, class_name: 'AttendeeFieldValue', dependent: :destroy

  validates_presence_of :first_name, :last_name, :email
  validates_email_format_of :email

  CORE_PARAMS = %i[first_name last_name email note created_at checked_in_at checked_out_at].freeze

  # returns an object containing all attendee data
  def attrs
    attributes.to_h.slice(*CORE_PARAMS.map(&:to_s)).merge(field_values)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def field_values
    data = {}
    values.each do |value|
      data[value.field.name] = value.content
    end
    data
  end

  def field_for(name)
    fields.where(name: name)
  end

  def checked_out?
    checked_out_at.present?
  end

  def checked_in?
    checked_in_at.present?
  end

  def checked_out_by
    User.find(checked_out_by_id)
  end

  def checked_in_by
    User.find(checked_in_by_id)
  end

  def both?
    checked_out? && checked_in?
  end

  def self.checked_in_total
    all.checked_in.count
  end

  def self.checked_in_and_out_total
    all.checked_in_and_out.count
  end

  def self.as_csv
    CSV.generate do |csv|
      keys = CORE_PARAMS.map(&:to_s) + all.first.field_values.keys
      csv << keys
      all.each do |item|
        csv << item.attrs.values
      end
    end
  end

  def self.import_csv(file, event)
    CSV.foreach(file.path, headers: true) do |row|
      row = row.to_h
      core_keys = CORE_PARAMS.map(&:to_s)
      # Create attendee record with core params
      record = event.attendees.create(row.slice(*core_keys))
      # Save custom field values for attendee
      row.except(*core_keys).each do |name, value|
        field = event.fields.where(name: name).first
        record.values.create!(field: field, content: value.to_s)
      end
    end
  end
end
