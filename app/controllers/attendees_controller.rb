class AttendeesController < ApplicationController
  before_action :set_event, only: %i[index show new edit update destroy]

  def index
    @attendees = @event.attendees
    render react_component: 'Attendees', props: {
      attendees: @attendees.as_json,
      event: @event.as_json
    }
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
