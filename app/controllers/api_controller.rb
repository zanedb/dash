class ApiController < ApplicationController
  before_action :set_event
  skip_before_action :verify_authenticity_token

  CORE_PARAMS = %i[first_name last_name email note]

  def new_attendee
    @attendee = @event.attendees.new(attendee_core_params)
    if @attendee.save
      @fields = @event.fields
      @fields.each do |field|
        @attendee.values.create!(field: field, content: attendee_params[field.name])
      end

      render json: @attendee.attrs.as_json, status: status
    else
      render json: { errors: @attendee.errors }, status: 400
    end
  end

  private

  def set_event
    @event = Event.friendly.find_by_friendly_id(params[:event_id])
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
