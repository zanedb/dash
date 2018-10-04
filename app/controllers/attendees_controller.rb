class AttendeesController < ApplicationController
  before_action :set_event
  
  def index
    @attendees = @event.attendees
    render react_component: 'Attendees', props: {
      attendees: @attendees.as_json,
      event: @event.as_json
    }
  end

  def new
    render react_component: 'AttendeesNew', props: { event: @event.as_json }
  end

  def create
    @attendee = @event.attendees.new(attendee_params)

    if @attendee.save
      redirect_to @attendee, notice: 'Attendee was successfully created.'
    else
      render :new
    end
  end

  def update
    if @attendee.update(attendee_params)
      redirect_to @attendee, notice: 'Attendee was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendee.destroy
    redirect_to attendees_url, notice: 'Attendee was successfully destroyed.'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def attendee_params
    params.require(:attendee).permit(:fname, :lname, :email, :note, :extras)
  end
end
