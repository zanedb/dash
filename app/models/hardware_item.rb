# frozen_string_literal: true

class HardwareItem < ApplicationRecord
  scope :not_checked_out, -> { where(checked_out_at: nil) }
  scope :checked_out_and_in, -> { where.not(checked_out_at: nil, checked_in_at: nil) }

  belongs_to :hardware
  has_one_attached :checked_out_to_file

  self.primary_key = :barcode

  before_create :set_barcode

  def set_barcode
    # terrible solution lol
    code = gen_barcode
    code = gen_barcode until HardwareItem.find_by(barcode: new_barcode).blank?
    self.barcode = code
  end

  def gen_barcode
    10.times.map { rand(10) }.join
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

  def checked_out_by
    User.find(checked_out_by_id)
  end

  def checked_in_by
    User.find(checked_in_by_id)
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
