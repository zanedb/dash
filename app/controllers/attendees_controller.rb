class AttendeesController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_attendee, only: %i[show edit update destroy]

  def index
    @attendees = @event.attendees

    respond_to do |format|
      format.html
      format.csv { send_data @attendees.as_csv }
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
      flash[:notice] = 'Attendee was successfully created.'
    else
      render :new
    end
  end

  def update
    if @attendee.update(attendee_params)
      redirect_to event_attendee_path(@event, @attendee)
      flash[:notice] = 'Attendee was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendee.destroy
    redirect_to event_attendees_path(@event)
    flash[:notice] = 'Attendee was successfully destroyed.'
  end

  private

  def set_event
    # don't allow fetching by numeric IDs, only by slug
    @event = Event.friendly.find(params[:event_id]) unless params[:event_id] =~ /^[0-9]+$/
    raise ActiveRecord::RecordNotFound unless @event
    raise ActiveRecord::RecordNotFound unless @event.users.include?(current_user) || current_user.admin?
  end

  def set_attendee
    @attendee = @event.attendees.find(params[:id])
  end

  def attendee_params
    params.require(:attendee).permit(:fname, :lname, :email, :note, :extras)
  end
end
