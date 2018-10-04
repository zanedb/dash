class Event < ApplicationRecord
  validates :name, :startDate, :endDate, :location, presence: true
end
