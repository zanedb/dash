class EventsController < ApplicationController
  def index
    render react_component: 'Events'
  end

  def new
    render react_component: 'EventsNew'
  end
end
