class Hardware < ApplicationRecord
  extend FriendlyId

  belongs_to :event
  has_many :hardware_items

  validates_presence_of :vendor, :model, :quantity

  def description
    "#{vendor} #{model}"
  end

  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [
      [:vendor, :model]
    ]
  end
end
