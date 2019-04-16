class RegistrationConfig < ApplicationRecord
  belongs_to :event, touch: true

  def open?
    open_at.present?
  end

  def closed?
    !open?
  end
end
