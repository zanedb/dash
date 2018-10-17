class Event < ApplicationRecord
  extend FriendlyId

  default_scope { order(id: :asc) }

  has_many :attendees, dependent: :destroy
  has_many :organizer_positions, dependent: :destroy
  has_many :organizer_position_invites, dependent: :destroy
  has_many :users, through: :organizer_positions
  
  validates :name, :start_date, :end_date, :location, :user_id, presence: true

  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [
      :name,
      [:name, :start_date],
      [:name, :location]
    ]
  end
end
