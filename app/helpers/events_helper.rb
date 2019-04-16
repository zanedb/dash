# frozen_string_literal: true

module EventsHelper
  def event_length(event)
    "#{local_time(event.start_date, '%B %e')}-#{local_time(event.end_date, '%e, %Y')}"
  end

  def registration_status_banner event
    if event.registration_closed?
      content_tag :div, class: 'flash__full flash__registration-closed full-width' do
        content_tag :p do
          content_tag(:span, 'Registration is closed — attendees can only be added manually. ') +
          link_to('Configure registration', event_attendee_fields_path(@event)) +
          content_tag(:span, '.')
        end
      end
    end
  end
end