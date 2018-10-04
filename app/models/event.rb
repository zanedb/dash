class Event < ApplicationRecord
  has_many :attendees
  validates :name, :startDate, :endDate, :location, presence: true
end
