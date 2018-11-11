class AttendeeFieldsController < ApplicationController
  before_action :set_event
  before_action :set_attendee_field, only: %i[show edit update destroy]

  def index
    # manually authenticate index methods, Pundit doesn't
    unless @event.users.include?(current_user) || current_user.admin?
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  def show
  end

  def new
    @attendee_field = @event.fields.new
  end

  def edit
  end

  def create
    @attendee_field = @event.fields.new(attendee_field_params)

    if @attendee_field.save
      redirect_to event_attendee_fields_path(@event)
      flash[:success] = 'Field was successfully created.'
    else
      render :new
    end
  end

  def update
    if @attendee_field.update(attendee_field_params)
      redirect_to event_attendee_fields_path(@event)
      flash[:success] = 'Field was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendee_field.destroy
    redirect_to event_attendee_fields_path(@event)
    flash[:success] = 'Field was successfully destroyed.'
  end

  private

  def set_event
    # don't allow fetching by numeric IDs, only by slug
    @event = Event.friendly.find(params[:event_id]) unless params[:event_id] =~ /^[0-9]+$/
    raise ActiveRecord::RecordNotFound unless @event
    authorize @event
  end

  def set_attendee_field
    @attendee_field = @event.fields.find(params[:id])
  end

  def attendee_field_params
    params.require(:attendee_field).permit(:name, :label, :kind, :options)
  end
end
