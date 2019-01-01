# frozen_string_literal: true

module EventsHelper
  def event_length(event)
    "#{local_time(event.start_date, '%B %e')}-#{local_time(event.end_date, '%e, %Y')}"
  end
end