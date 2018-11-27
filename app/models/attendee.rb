require 'csv'

class Attendee < ApplicationRecord
  include SearchCop

  search_scope :search do
    attributes [:first_name, :last_name], :email
  end

  belongs_to :event
  has_many :fields, through: :values, class_name: 'AttendeeField'
  has_many :values, class_name: 'AttendeeFieldValue', dependent: :destroy

  validates_presence_of :first_name, :last_name, :email
  validates_email_format_of :email

  def attrs
    attributes.to_h.merge(field_values).except('event_id')
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

  def checked_in?
    checked_in_at.present?
  end

  def checked_out?
    !checked_in?
  end

  def self.as_csv
    CSV.generate do |csv|
      filtered_columns = column_names - ['event_id'] # hide event_id in CSV
      csv << filtered_columns
      all.each do |item|
        csv << item.attributes.values_at(*filtered_columns)
      end
    end
  end
end
