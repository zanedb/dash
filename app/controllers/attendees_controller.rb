# frozen_string_literal: true

class AttendeesController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_attendee, only: %i[show edit update destroy check_in check_out reset_status]
  before_action -> { authorize @attendee }, only: %i[show edit update destroy check_in check_out reset_status]
  before_action :custom_authorization, only: %i[index import import_csv]

  CORE_PARAMS = %i[first_name last_name email note].freeze

  def index
    @attendees = @event.attendees
    @attendees_new_week_count = @attendees.where('created_at > ?', 1.week.ago).count

    respond_to do |format|
      format.html do
        render :index, layout: 'react'
      end
      format.csv do
        if @attendees.present?
          send_data @attendees.as_csv
        else
          flash[:error] = 'No attendees available.'
          redirect_to event_attendees_path(@event)
        end
      end
    end
  end

  def show
    @attendee_fields = @event.fields

    respond_to do |format|
      format.html
      format.pdf do
        send_data @attendee.waiver_pdf
      end
    end
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

    # this passes parameters through to some internal model methods, it is very important -me@tmb.sh
    @attendee.set_attendee_params(attendee_params)

    if @attendee.save
      redirect_to event_attendee_path(@event, @attendee)
      flash[:success] = 'Attendee was successfully created.'
    else
      render :new
    end
  end

  def update
    # this passes parameters through to some internal model methods, it is very important -me@tmb.sh
    @attendee.set_attendee_params(attendee_params)

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
    if @attendee.update(
      checked_in_at: Time.current,
      checked_in_by_id: current_user_id,
      checked_out_at: nil,
      checked_out_by_id: nil
    )
      flash[:success] = 'Successfully checked-in attendee.'
      redirect_to request.referrer || event_attendees_path(@event)
    else
      flash[:error] = 'Failed to check-in attendee.'
      redirect_to request.referrer || event_attendee_path(@event, @attendee)
    end
  end

  def check_out
    return false if @attendee.checked_out?

    if @attendee.update(checked_out_at: Time.current, checked_out_by_id: current_user_id)
      flash[:success] = 'Successfully checked-out attendee.'
      redirect_to request.referrer || event_attendees_path(@event)
    else
      flash[:error] = 'Failed to check-out attendee.'
      redirect_to request.referrer || event_attendee_path(@event, @attendee)
    end
  end

  def reset_status
    if @attendee.update(
      checked_in_at: nil,
      checked_in_by_id: nil,
      checked_out_at: nil,
      checked_out_by_id: nil
    )
      flash[:success] = 'Successfully reset attendee status.'
      redirect_to request.referrer || event_attendees_path(@event)
    else
      flash[:error] = 'Failed to reset attendee status.'
      redirect_to request.referrer || event_attendee_path(@event, @attendee)
    end
  end

  def import; end

  def import_csv
    begin
      Attendee.import_csv(params[:file], @event)
      flash[:success] = 'Imported CSV of attendees.'
    rescue StandardError
      flash[:error] = 'Invalid CSV.'
    end
    redirect_to event_attendees_path(@event)
  end

  private

  def custom_authorization
    skip_authorization
    # manually authenticate certain methods, Pundit can't
    unless @event.users.include?(current_user) || current_user.admin?
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  def set_attendee
    @attendee = @event.attendees.friendly.find_by_friendly_id(params[:id])
  end

  def attendee_params
    params
      .require(:attendee)
      .permit([CORE_PARAMS].push(@event.fields.collect(&:name).map(&:to_sym)).flatten)
  end

  def attendee_core_params
    attendee_params.to_h.slice(*CORE_PARAMS)
  end

  def attendee_field_params
    attendee_params.to_h.slice(*@event.fields.collect(&:name).map(&:to_sym))
  end
end
