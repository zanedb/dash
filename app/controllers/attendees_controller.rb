class AttendeesController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_attendee, only: %i[show edit update destroy]

  def index
    # manually authenticate index methods, Pundit doesn't
    if @event.users.include?(current_user) || current_user.admin?
      @attendees = @event.attendees

      respond_to do |format|
        format.html
        format.csv { send_data @attendees.as_csv }
      end
    else
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  def show
  end

  def new
    @attendee = @event.attendees.new
  end

  def edit
  end

  def create
    @attendee = @event.attendees.new(attendee_params)

    if @attendee.save
      redirect_to event_attendee_path(@event, @attendee)
      flash[:success] = 'Attendee was successfully created.'
    else
      render :new
    end
  end

  def update
    if @attendee.update(attendee_params)
      redirect_to event_attendee_path(@event, @attendee)
      flash[:success] = 'Attendee was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendee.destroy
    redirect_to event_attendees_path(@event)
    flash[:success] = 'Attendee was successfully destroyed.'
  end

  private

  def set_event
    # don't allow fetching by numeric IDs, only by slug
    @event = Event.friendly.find(params[:event_id]) unless params[:event_id] =~ /^[0-9]+$/
    raise ActiveRecord::RecordNotFound unless @event
    authorize @event
  end

  def set_attendee
    @attendee = @event.attendees.find(params[:id])
  end

  def attendee_params
    params.require(:attendee).permit(:first_name, :last_name, :email, :note, :extras)
  end
end
