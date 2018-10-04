import React from 'react'
import AttendeeForm from '../../../components/events/attendees/AttendeeForm'

export default ({ attendee, event }) => (
  <div>
    <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
    <a href={`/events/${event.id}`}>{event.name}</a> ›{' '}
    <a href={`/events/${event.id}/attendees`}>Attendees</a> ›{' '}
    <a href="#">Edit Attendee</a>
    <h1>
      {attendee.fname} {attendee.lname}
    </h1>
    <AttendeeForm
      url={`/events/${event.id}/attendees/${attendee.id}`}
      method="PUT"
      values={attendee}
    />
  </div>
)
