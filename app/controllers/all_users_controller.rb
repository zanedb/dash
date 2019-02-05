# frozen_string_literal: true

class AllUsersController < ApplicationController
  before_action :please_sign_in
  before_action -> { record_not_authorized unless current_user.admin? }, except: %i[stop_impersonating]
  before_action :set_user, except: %i[stop_impersonating]

  def show; end

  def impersonate
    impersonate_user @user
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
