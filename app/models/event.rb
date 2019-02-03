class Event < ApplicationRecord
  extend FriendlyId

  default_scope { order(start_date: :asc) }

  has_one :waiver, dependent: :destroy

  has_many :attendees, dependent: :destroy
  has_many :fields, class_name: 'AttendeeField', dependent: :destroy
  has_many :webhooks, dependent: :destroy
  has_many :organizer_positions, dependent: :destroy
  has_many :organizer_position_invites, dependent: :destroy
  has_many :users, through: :organizer_positions
  has_many :hardwares, dependent: :destroy
  has_many :hardware_items, through: :hardwares, dependent: :destroy

  after_create { create_waiver! }

  validates :name, :start_date, :end_date, :city, :user_id, presence: true
  validate :permitted_domains_cannot_have_trailing_slash

  def permitted_domains_cannot_have_trailing_slash
    permitted_domains.split(',').each do |domain|
      if domain[-1] == '/'
        errors.add(:permitted_domains, 'cannot contain trailing slashes')
      end
    end
  end

  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [
      :name,
      [:name, :city],
      [:name, :start_date]
    ]
  end
end
