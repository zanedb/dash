import React from 'react'
import EventForm from '../../components/events/EventForm'

export default ({ event }) => (
  <div>
    <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
    <a href={`/events/${event.id}`}>{event.name}</a> ›{' '}
    <a href="#">Edit Event</a>
    <h1>{event.name}</h1>
    <EventForm url={`/events/${event.id}`} method="PUT" values={event} />
  </div>
)
