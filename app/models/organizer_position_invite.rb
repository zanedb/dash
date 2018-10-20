# frozen_string_literal: true

# OrganizerPositionInvites are used to invite users, whether they already
# exist or not, to manage an Event.
#
# The User being invited may or may not already exist, usually not.
#
# Scenario 1: User being invited does not yet exist in the database
#
# 1. OrganizerPositionInvite is created, event/email are set. User is not.
# 2. Notification email is sent to invitee
# 3. Invitee visits URL, is directed to create an account, creating User record.
# 4. Trigger in User is created that searches for OrganizerPositionInvites with
#    an email match that don't yet have an associated User, associates them.
#
# Scenario 2: User being invited exists in the database
#
# 1. OrganizerPositionInvite is created. Event, email, and User all get set.
# 2. Notification email is sent.
#
# Thank you to Hack Club Bank for help here!

class OrganizerPositionInvite < ApplicationRecord
  scope :pending, -> { where(accepted_at: nil, rejected_at: nil) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :rejected, -> { where.not(rejected_at: nil) }

  belongs_to :event
  belongs_to :user, required: false
  belongs_to :sender, class_name: 'User'

  belongs_to :organizer_position, required: false

  validates_email_format_of :email

  validates :accepted_at, absence: true, if: -> { rejected_at.present? }
  validates :rejected_at, absence: true, if: -> { accepted_at.present? }

  after_create :send_email

  def send_email
    OrganizerPositionInvitesMailer.with(invite: self).notify.deliver_later
  end

  def accept
    unless user.present?
      errors.add(:user, 'must be present to accept invite')
      return false
    end

    if accepted?
      errors.add(:base, 'already accepted!')
      return false
    end

    self.organizer_position = OrganizerPosition.new(
      event: event,
      user: user
    )

    update(accepted_at: Time.current)
  end

  def reject
    unless user.present?
      errors.add(:user, 'must be present to accept invite')
      return false
    end

    if rejected?
      errors.add(:base, 'already rejected!')
      return false
    end

    update(rejected_at: Time.current)
  end

  def rejected?
    rejected_at.present?
  end

  def accepted?
    accepted_at.present?
  end
end
