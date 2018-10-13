# frozen_string_literal: true

class OrganizerPositionInvitePolicy < ApplicationPolicy
  def new?
    user.admin? || record.event&.users&.include?(user)
  end

  def create?
    user.admin? || record.event.users.include?(user)
  end

  def show?
    if record.accepted_at || record.rejected_at
      false
    else
      record.user == user || user.admin?
    end
  end

  def new?
    record.event&.users&.include?(user) || user.admin?
  end

  def accept?
    record.user == user
  end

  def reject?
    record.user == user
  end
end
