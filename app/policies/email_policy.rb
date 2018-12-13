# frozen_string_literal: true

class EmailPolicy < ApplicationPolicy
  def show?
    record.event.users.include?(user) || user.admin?
  end

  def new?
    record.event.users.include?(user) || user.admin?
  end

  def create?
    record.event.users.include?(user) || user.admin?
  end
end
