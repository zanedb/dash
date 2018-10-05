class EventsController < ApplicationController
  before_action :please_sign_in
  before_action :set_event, only: %i[show edit update destroy]
  before_action -> { hey_thats_my @event }, only: %i[show edit update destroy]

  # GET /events
  def index
    @events = current_user.events
    render react_component: 'Events', props: { events: @events.as_json }
  end

  # GET /events/1
  def show
    render react_component: 'Event', props: { event: @event.as_json }
  end

  # GET /events/new
  def new
    render react_component: 'EventsNew'
  end

  # GET /events/1/edit
  def edit
    render react_component: 'EventsEdit', props: { event: @event.as_json }
  end

  # POST /events
  def create
    @event = Event.new(event_params.merge(user_id: current_user_id))

    if @event.save
      redirect_to @event, flash[:notice] = 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, flash[:notice] = 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, flash[:notice] = 'Event was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name, :startDate, :endDate, :location)
  end
end
