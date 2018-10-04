import React from 'react'
import EventForm from '../../components/events/EventForm'

export default () => (
  <div>
    <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
    <a href="#">Add Event</a>
    <h1>Add an Event</h1>
    <EventForm url="/events" method="POST" />
  </div>
)
