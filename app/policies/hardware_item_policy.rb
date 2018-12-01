# frozen_string_literal: true

class HardwareItemPolicy < ApplicationPolicy
  def show?
    record.hardware.event.users.include?(user) || user.admin?
  end

  def new?
    record.hardware.event.users.include?(user) || user.admin?
  end

  def edit?
    record.hardware.event.users.include?(user) || user.admin?
  end

  def create?
    record.hardware.event.users.include?(user) || user.admin?
  end

  def update?
    record.hardware.event.users.include?(user) || user.admin?
  end

  def destroy?
    record.hardware.event.users.include?(user) || user.admin?
  end

  def check_in?
    record.hardware.event.users.include?(user) || user.admin?
  end

  def check_out?
    record.hardware.event.users.include?(user) || user.admin?
  end
end
