import React from 'react'
import AttendeeForm from '../../../components/events/attendees/AttendeeForm'

export default ({ event }) => (
  <div>
    <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
    <a href={`/events/${event.id}`}>{event.name}</a> ›{' '}
    <a href={`/events/${event.id}/attendees`}>Attendees</a> ›{' '}
    <a href="#">Add Attendee</a>
    <h1>Add an Attendee</h1>
    <AttendeeForm url={`/events/${event.id}/attendees`} method="POST" />
  </div>
)
