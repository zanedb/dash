class RegistrationConfig < ApplicationRecord
  belongs_to :event

  validates_presence_of :goal

  def open?
    open_at.present?
  end

  def closed?
    !open?
  end
end