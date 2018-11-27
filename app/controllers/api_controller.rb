class ApiController < ApplicationController
  before_action :set_event
  before_action :block_unpermitted_requests
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

  def block_unpermitted_requests
    # only allow requests from permitted domains
    unless @event.permitted_domains.blank?
      permitted_domains = @event.permitted_domains.gsub(/\s+/, '').split(',')
      unless permitted_domains.include?(request.headers['origin'])
        render json: {
          errors: {
            request: ['is not from a permitted domain']
          }
        }, status: 400
        return
      end
    end
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
