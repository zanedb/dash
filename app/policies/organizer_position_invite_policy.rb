# frozen_string_literal: true

class OrganizerPositionInvitePolicy < ApplicationPolicy
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

  def destroy?
    user.admin?
  end

  def accept?
    record.user == user
  end

  def reject?
    record.user == user
  end
end
