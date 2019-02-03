# frozen_string_literal: true

class AllUsersController < ApplicationController
  before_action :please_sign_in
  before_action -> { record_not_authorized unless current_user.admin? }

  def show
    @user = User.find(params[:id])
  end
end
