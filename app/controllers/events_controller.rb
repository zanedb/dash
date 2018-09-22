class EventsController < ApplicationController
  def index

  end

  def new
    render react_component: 'EventsNew'
  end
end
