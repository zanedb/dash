# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :please_sign_in
  before_action :set_event, only: %i[show edit update destroy]
  before_action -> { authorize @event }, only: %i[show edit update destroy]

  # GET /events
  def index
    redirect_to root_url
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name, :start_date, :end_date, :location, :permitted_domains, :webhook_post_url)
  end
end
