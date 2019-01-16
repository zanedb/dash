class AttendeeWaiver < ApplicationRecord
  belongs_to :waiver, touch: true
  belongs_to :attendee, touch: true

  has_one_attached :file

  has_secure_token :access_token

  validates_presence_of :file
  validates :file, file_size: { less_than_or_equal_to: 20.megabytes, message: 'must be less than 20mb' },
                   file_content_type: { allow: 'application/pdf', message: 'must be a PDF' }

  def signed?
    file.attached?
  end

  def unsigned?
    !signed?
  end
end
