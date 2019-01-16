class AttendeeWaiversController < ApplicationController
  before_action :set_event
  before_action :set_waiver
  before_action :validate_token

  def show
  end

  def update
    if @waiver.update(waiver_params)
      flash[:success] = 'Signed waiver has been uploaded!'
      redirect_to request.referrer || event_attendee_waiver_path(@event, @waiver, access_token: @waiver.access_token)
    else
      render :show
    end
  end

  private

  def set_waiver
    @waiver = @event.waiver.attendee_waivers.find(params[:id])
  end

  def validate_token
    unless params[:access_token] == @waiver.access_token || current_user.admin?
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  def waiver_params
    params.require(:attendee_waiver).permit(:file)
  end
end
