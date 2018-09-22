class EventsController < ApplicationController
  def index

  end

  def new
    render react_component 'pages/EventsNew' # WHYYY DOES THIS RETURN A `NoMethodError` AAAAAAAAA
  end
end
