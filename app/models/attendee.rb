require 'csv'

class Attendee < ApplicationRecord
  belongs_to :event
  has_many :attendee_field_values, through: :attendee_fields, dependent: :destroy

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
