require 'csv'

class Attendee < ApplicationRecord
  belongs_to :event
  has_many :fields, through: :values, class_name: 'AttendeeField'
  has_many :values, class_name: 'AttendeeFieldValue', dependent: :destroy

  def name
    "#{first_name} #{last_name}"
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
