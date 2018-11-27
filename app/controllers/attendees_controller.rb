# frozen_string_literal: true

class AttendeesController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_attendee, only: %i[show edit update destroy check_in check_out]
  before_action -> { authorize @attendee }, only: %i[show edit update destroy check_in check_out]

  CORE_PARAMS = %i[first_name last_name email note].freeze

  def index
    skip_authorization
    # manually authenticate index methods, Pundit doesn't
    if @event.users.include?(current_user) || current_user.admin?
      @attendees = if params[:search]
                     @event.attendees.search(params[:search])
                   else
                     @event.attendees
                   end
      @attendees_new_week_count = @attendees.where('created_at > ?', 1.week.ago).count

      respond_to do |format|
        format.html
        format.csv { send_data @attendees.as_csv }
      end
    else
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  def show
    @attendee_fields = @event.fields
  end

  def new
    @attendee = @event.attendees.new
    authorize @attendee
  end

  def edit
    @values = @attendee.field_values
  end

  def create
    @attendee = @event.attendees.new(attendee_core_params)
    authorize @attendee
    if @attendee.save
      @fields = @event.fields
      @fields.each do |field|
        @attendee.values.create!(field: field, content: attendee_params[field.name])
      end
      redirect_to event_attendee_path(@event, @attendee)
      flash[:success] = 'Attendee was successfully created.'
    else
      render :new
    end
  end

  def update
    @fields = @event.fields.includes(:values)
    @fields.each do |field|
      field.value_for(@attendee).update(content: attendee_params[field.name])
    end
    if @attendee.update(attendee_core_params)
      redirect_to event_attendee_path(@event, @attendee)
      flash[:success] = 'Attendee was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendee.destroy
    redirect_to event_attendees_path(@event)
    flash[:success] = 'Attendee was successfully destroyed.'
  end

  def check_in
    if @attendee.update(checked_in_at: Time.current, checked_in_by_id: current_user_id)
      flash[:success] = 'Successfully checked-in attendee.'
      redirect_to event_attendees_path(@event)
    else
      flash[:error] = 'Failed to check-in attendee.'
      redirect_to event_attendee_path(@event, @attendee)
    end
  end

  def check_out
    if @attendee.update(checked_in_at: nil, checked_in_by_id: nil)
      flash[:success] = 'Successfully checked-out attendee.'
      redirect_to event_attendees_path(@event)
    else
      flash[:error] = 'Failed to check-out attendee.'
      redirect_to event_attendee_path(@event, @attendee)
    end
  end

  private

  def set_attendee
    @attendee = @event.attendees.find(params[:id])
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
