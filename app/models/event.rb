class Event < ApplicationRecord
  extend FriendlyId

  default_scope { order(start_date: :desc) }

  has_one :waiver, dependent: :destroy
  has_one :registration_config, dependent: :destroy

  has_many :attendees, dependent: :destroy
  has_many :fields, class_name: 'AttendeeField', dependent: :destroy
  has_many :webhooks, dependent: :destroy
  has_many :organizer_positions, dependent: :destroy
  has_many :organizer_position_invites, dependent: :destroy
  has_many :users, through: :organizer_positions
  has_many :hardwares, dependent: :destroy
  has_many :hardware_items, through: :hardwares, dependent: :destroy

  after_create { create_waiver! }
  after_create { create_registration_config! }

  validates :name, :start_date, :end_date, :city, presence: true

  def past?
    end_date.past?
  end

  def future?
    start_date.future?
  end

  def filter_data
    { exists: true, past: past?, future: future? }
  end

  def registration_open?
    registration_config.open?
  end

  def registration_closed?
    !registration_open?
  end

  private

  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [:name, [:name, :city], [:name, :start_date]]
  end
end
