# frozen_string_literal: true

class WebhookPolicy < ApplicationPolicy
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
