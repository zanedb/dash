# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :please_sign_in
  before_action :set_event, except: %i[index new create]
  before_action lambda {  authorize @event }, except: %i[index new create embed_js]
  protect_from_forgery except: :embed_js

  # GET /events
  def index
    if current_user.admin?
      @events = Event.all
    else
      redirect_to root_url
    end
  end

  # GET /events/1
  def show
    @invites = @event.organizer_position_invites
    @attendees = @event.attendees
    @attendees_new_week_count =
      @attendees.where('created_at > ?', 1.week.ago).count
  end

  # GET /events/new
  def new
    authorize Event
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events
  def create
    authorize Event
    @event = Event.new(event_params.merge(user_id: current_user_id))

    if @event.save
      redirect_to @event
      flash[:success] = 'Event created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event
      flash[:success] = 'Event settings updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url
    flash[:success] = 'Event destroyed.'
  end
  
  def team
    @invite = OrganizerPositionInvite.new
    @invite.event = @event
  end

  def embed_js
    @attendee = @event.attendees.new
    render :embed, layout: false
  end

  def configure
    if @event.registration_config.update(registration_config_params)
      redirect_to request.referrer || event_path(@event)
      flash[:success] = 'Registration configured.'
    else
      render :edit
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(
      :name,
      :start_date,
      :end_date,
      :city,
      :permitted_domains
    )
  end
end
