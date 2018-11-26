# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :please_sign_in
  before_action -> { record_not_authorized unless current_user.admin? }

  def index; end

  def all_users
    @users = User.all
    @users_new_week_count = User.where('created_at > ?', 1.week.ago).count
    @users_active_count = User.where('last_sign_in_at > ?', 1.week.ago).count
  end
end
