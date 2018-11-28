class Hardware < ApplicationRecord
  belongs_to :event

  self.primary_key = :barcode

  validates_presence_of :vendor, :model, :barcode
  validates_uniqueness_of :barcode

  before_create :set_barcode

  def set_barcode
    self.barcode = 10.times.map { rand(10) }.join
  end

  def to_param
    "#{self.barcode}"
  end

  def description
    "#{vendor} #{model} (#{barcode})"
  end

  def checked_out?
    checked_out_at.present?
  end

  def checked_out_description
    if checked_out?
      "#{username} checked out to “#{checked_out_by.name}”"
    else
      'not checked out'
    end      
  end    
end
