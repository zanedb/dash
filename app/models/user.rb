require 'digest/md5'

class User < ApplicationRecord
  # Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  validates :name, presence: true

  has_many :organizer_position_invites, dependent: :destroy
  has_many :organizer_positions, dependent: :destroy
  has_many :events, through: :organizer_positions

  after_create :check_for_invitations

  def check_for_invitations
    invite = OrganizerPositionInvite.find_by email: email, user: nil
    if invite
      invite.user = self
      invite.save
    end
  end

  def make_admin!
    self.admin_at = Time.current
  end

  def remove_admin!
    self.admin_at = nil
  end

  def admin?
    admin_at.present?
  end
end
