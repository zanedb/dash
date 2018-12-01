# frozen_string_literal: true

class Hardware < ApplicationRecord
  extend FriendlyId

  belongs_to :event
  has_many :hardware_items, dependent: :destroy

  validates_presence_of :vendor, :model, :quantity
  validate :quantity_limits

  after_create :create_hardware_items
  after_update :update_hardware_items

  def create_hardware_items
    quantity.times do
      hardware_items.create!(
        checked_out_by_id: nil,
        checked_out_to: nil,
        checked_out_at: nil
      )
    end
  end

  def update_hardware_items
    old_quantity = hardware_items.count
    if quantity > old_quantity
      diff = quantity - old_quantity
      diff.times do
        hardware_items.create!(
          checked_out_by_id: nil,
          checked_out_to: nil,
          checked_out_at: nil
        )
      end
    end
  end

  def quantity_limits
    if quantity < hardware_items.count
      errors.add(
        :quantity,
        'cannot be decreased, only increased. You must manually remove barcodes.'
      )
    end
  end

  def description
    "#{vendor} #{model}"
  end

  def available
    hardware_items.not_checked_out.count + hardware_items.checked_out_and_in.count
  end

  friendly_id :slug_candidates, use: :slugged
  def slug_candidates
    [
      %i[vendor model]
    ]
  end
end
