# frozen_string_literal: true

class Waiver < ApplicationRecord
  belongs_to :event, touch: true
  has_one_attached :file

  validates_presence_of :file
  validates :file, file_size: { less_than_or_equal_to: 20.megabytes, message: 'must be less than 20mb' },
                              file_content_type: { allow: 'application/pdf', message: 'must be a PDF' }

  def enabled?
    file.attached?
  end

  def disabled?
    !enabled?
  end
end
