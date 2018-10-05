class Event < ApplicationRecord
  extend FriendlyId
  belongs_to :user, touch: true
  has_many :attendees
  validates :name, :startDate, :endDate, :location, :user_id, presence: true

  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [
      :name,
      [:name, :startDate],
      [:name, :location]
    ]
  end
end
