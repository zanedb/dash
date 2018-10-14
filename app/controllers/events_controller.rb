# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :please_sign_in
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events
  def index
    authorize Event
    @events = if current_user.admin?
                Event.all
              else
                current_user.events
              end
    @invites = current_user.organizer_position_invites.pending
  end

  # GET /events/1
  def show
    @invites = @event.organizer_position_invites
  end

  # GET /events/new
  def new
    authorize Event
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    authorize Event
    @event = Event.new(event_params.merge(user_id: current_user_id))

    if @event.save
      redirect_to @event
      flash[:success] = 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event
      flash[:success] = 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url
    flash[:success] = 'Event was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    # don't allow fetching by numeric IDs, only by slug
    @event = Event.friendly.find(params[:id]) unless params[:id] =~ /^[0-9]+$/
    raise ActiveRecord::RecordNotFound unless @event
    authorize @event
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name, :startDate, :endDate, :location)
  end
end
