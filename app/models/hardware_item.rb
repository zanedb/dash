# frozen_string_literal: true

class HardwareItem < ApplicationRecord
  belongs_to :hardware

  self.primary_key = :barcode

  before_create :set_barcode

  def set_barcode
    self.barcode = 10.times.map { rand(10) }.join
    # TODO fix so that if barcode generated already exists it doesnt fail
  end

  def to_param
    barcode
  end

  def description
    "#{hardware.vendor} #{hardware.model} (#{barcode})"
  end

  def checked_out?
    checked_out_at.present?
  end

  def checked_in?
    !checked_out_at.present?
  end

  def checked_out_description
    if checked_out?
      "#{username} checked out to “#{checked_out_by.name}”"
    else
      'not checked out'
    end
  end

  def check_in!
    update(
      checked_out_by_id: nil,
      checked_out_to: nil,
      checked_out_at: nil
    )
  end
end
