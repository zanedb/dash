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
    "#{hardware.vendor} #{hardware.model}—#{barcode}"
  end

  def checked_out?
    checked_out_at.present?
  end

  def checked_in?
    checked_in_at.present?
  end

  def both?
    checked_out? && checked_in?
  end

  def checked_out_description
    if checked_out?
      "#{description} checked out by “#{checked_out_by.name}”"
    elsif checked_in?
      "#{description} checked in by “#{checked_out_by.name}”"
    end
  end
end
