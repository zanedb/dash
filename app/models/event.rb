class Event < ApplicationRecord
  belongs_to :user, touch: true
  has_many :attendees
  validates :name, :startDate, :endDate, :location, :user_id, presence: true
end
