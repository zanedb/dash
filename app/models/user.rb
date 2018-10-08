class User < ApplicationRecord
  # Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  validates :name, presence: true

  has_many :events

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
