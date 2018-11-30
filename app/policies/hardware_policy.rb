# frozen_string_literal: true

class HardwarePolicy < ApplicationPolicy
  def show?
    record.event.users.include?(user) || user.admin?
  end

  def new?
    record.event.users.include?(user) || user.admin?
  end

  def edit?
    record.event.users.include?(user) || user.admin?
  end

  def create?
    record.event.users.include?(user) || user.admin?
  end

  def update?
    record.event.users.include?(user) || user.admin?
  end

  def destroy?
    record.event.users.include?(user) || user.admin?
  end
end
