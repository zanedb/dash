class ApiController < ApplicationController
  before_action :set_event
  
  CORE_PARAMS = %i[first_name last_name email note]

  def new_attendee
    @attendee = @event.attendees.new(attendee_core_params)
    if @attendee.save
      @fields = @event.fields
      @fields.each do |field|
        @attendee.values.create!(field: field, content: attendee_params[field.name])
      end

      render json: @attendee.attrs.as_json
    else
      render_error('server error', 500)
    end
  end

  def render_success(obj = { success: true }, status = 200)
      render json: obj, status: status
  end

  def render_error(msg, status = 400)
    render json: { error: msg }, status: status
  end

  private

  def set_event
    # don't allow fetching by numeric IDs, only by slug
    @event = Event.friendly.find(params[:event_id]) unless params[:event_id] =~ /^[0-9]+$/
    raise ActiveRecord::RecordNotFound unless @event
  end

  def attendee_params
    params
      .require(:attendee)
      .permit([CORE_PARAMS].push(@event.fields.collect(&:name).map(&:to_sym)).flatten)
  end

  def attendee_core_params
    attendee_params.to_h.slice(*CORE_PARAMS)
  end
end
