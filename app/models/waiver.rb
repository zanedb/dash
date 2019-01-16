# frozen_string_literal: true

class Waiver < ApplicationRecord
  belongs_to :event, touch: true
  has_one_attached :file

  validates :file, file_size: { less_than_or_equal_to: 20.megabytes, message: 'must be less than 20mb' },
                   file_content_type: { allow: 'application/pdf', message: 'must be a PDF' }

  has_many :attendee_waivers, dependent: :destroy

  after_update do
    if file.attached? && attendee_waivers.empty?
      event.attendees.each do |attendee|
        if attendee.attendee_waiver.nil?
          attendee.create_attendee_waiver!(waiver: self)
        end
      end
    end
  end

  def enabled?
    file.attached?
  end

  def disabled?
    !enabled?
  end
end
