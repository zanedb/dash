class AttendeeFieldsController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_attendee_field, only: %i[show edit update destroy]
  before_action -> { authorize @attendee_field }, only: %i[show edit update destroy]

  def index
    # manually authenticate index methods, Pundit doesn't
    unless @event.users.include?(current_user) || current_user.admin?
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end

    respond_to do |format|
      format.html
      format.json do
        render json: @event.fields.as_json
      end
    end
  end

  def show
  end

  def new
    @attendee_field = @event.fields.new
    authorize @attendee_field
  end

  def edit
  end

  def create
    @attendee_field = @event.fields.new(attendee_field_params)
    authorize @attendee_field

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

  def set_attendee_field
    @attendee_field = @event.fields.friendly.find_by_friendly_id(params[:id])
  end

  def attendee_field_params
    params.require(:attendee_field).permit(:name, :label, :kind, :options)
  end
end
