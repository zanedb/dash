class AttendeesController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action -> { hey_thats_my @event }

  before_action :set_attendee, only: %i[show edit update destroy]

  def index
    @attendees = @event.attendees
    render react_component: 'Attendees', props: {
      attendees: @attendees.as_json,
      event: @event.as_json
    }
  end

  def show
    render react_component: 'Attendee', props: {
      attendee: @attendee.as_json,
      event: @event.as_json
    }
  end

  def new
    render react_component: 'AttendeesNew', props: { event: @event.as_json }
  end

  def edit
    render react_component: 'AttendeesEdit', props: {
      attendee: @attendee.as_json,
      event: @event.as_json
    }
  end

  def create
    @attendee = @event.attendees.new(attendee_params)

    if @attendee.save
      redirect_to @attendee
      flash[:notice] = 'Attendee was successfully created.'
    else
      render :new
    end
  end

  def update
    if @attendee.update(attendee_params)
      redirect_to @attendee
      flash[:notice] = 'Attendee was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendee.destroy
    redirect_to event_path(@event)
    flash[:notice] = 'Attendee was successfully destroyed.'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_attendee
    @attendee = @event.attendees.find(params[:id])
  end

  def attendee_params
    params.require(:attendee).permit(:fname, :lname, :email, :note, :extras)
  end
end
