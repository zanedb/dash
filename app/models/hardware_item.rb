# frozen_string_literal: true

require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
require 'prawn'

class HardwareItem < ApplicationRecord
  scope :not_checked_out, -> { where(checked_out_at: nil) }
  scope :checked_out_and_in, -> { where.not(checked_out_at: nil, checked_in_at: nil) }

  default_scope { order(created_at: :desc) }

  belongs_to :hardware, touch: true
  has_one_attached :checked_out_to_file

  self.primary_key = :barcode

  before_create :set_barcode

  def set_barcode
    # terrible solution lol
    code = gen_barcode
    code = gen_barcode until HardwareItem.find_by(barcode: code).blank?
    self.barcode = code
  end

  def gen_barcode
    8.times.map { rand(8) }.join
  end

  def to_param
    barcode
  end

  def barcode_object
    Barby::Code128.new(barcode)
  end

  def barcode_svg
    barcode_object.to_svg(height: 30, xdim: 2, margin: 0)
  end

  def pdf
    barcode_object.to_pdf(y: 720)
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
