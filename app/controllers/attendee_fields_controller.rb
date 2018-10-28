class AttendeeFieldsController < ApplicationController
  before_action :set_event

  def index
    
  end

  private

  def set_event
    # don't allow fetching by numeric IDs, only by slug
    @event = Event.friendly.find(params[:event_id]) unless params[:event_id] =~ /^[0-9]+$/
    raise ActiveRecord::RecordNotFound unless @event
    authorize @event
  end
end
