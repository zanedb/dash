# frozen_string_literal: true

class AttendeeFieldPolicy < ApplicationPolicy
  def show?
    record.users.include?(user) || user.admin?
  end

  def new?
    record.users.include?(user) || user.admin?
  end

  def edit?
    record.users.include?(user) || user.admin?
  end

  def create?
    record.users.include?(user) || user.admin?
  end

  def update?
    record.users.include?(user) || user.admin?
  end

  def destroy?
    record.users.include?(user) || user.admin?
  end
end
