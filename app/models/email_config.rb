# frozen_string_literal: true

class EmailConfig < ApplicationRecord
  belongs_to :event

  def enabled?
    true unless [
      smtp_url, smtp_port, authentication, domain, sender_email, username, password
    ].any?(&:nil?)
  end
end
