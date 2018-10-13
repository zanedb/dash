class Event < ApplicationRecord
  extend FriendlyId

  default_scope { order(id: :asc) }

  has_many :attendees, dependent: :destroy
  has_many :organizer_positions
  has_many :organizer_position_invites
  has_many :users, through: :organizer_positions
  
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
