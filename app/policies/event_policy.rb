# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def index?
    user
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def show?
    record.users.include?(user) || user.admin?
  end

  def edit?
    record.users.include?(user) || user.admin?
  end

  def update?
    record.users.include?(user) || user.admin?
  end
end

