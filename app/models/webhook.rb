# frozen_string_literal: true

class Webhook < ApplicationRecord
  extend FriendlyId

  belongs_to :event

  validates_presence_of :name, :url, :request_type
  validates :request_type, inclusion: { 
    in: %w[GET POST],
    message: 'is invalid'
  }

  friendly_id :slug_candidates, use: :scoped, scope: :event
  def slug_candidates
    [
      name,
      %i[name request_type]
    ]
  end

  def limit_request_type
    # TODO: make sure only certain request types are accepted
  end
end
