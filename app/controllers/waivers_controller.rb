# frozen_string_literal: true

class WaiversController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_waiver
  before_action -> { authorize @waiver }, except: %i[index]

  def index
    # manually authenticate index methods, Pundit doesn't
    unless @event.users.include?(current_user) || current_user.admin?
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end
  
  def edit; end

  def update
    if @waiver.update(waiver_params)
      flash[:success] = 'Waiver was successfully configured.'
      redirect_to event_waivers_path(@event)
    else
      render :edit
    end
  end

  private

  def set_waiver
    @waiver = @event.waiver
  end

  def waiver_params
    params.require(:waiver).permit(:file, :require_signed_before_checkin)
  end
end
