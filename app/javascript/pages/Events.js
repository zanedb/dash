import React from 'react'

export default ({ events }) => (
  <div>
    <a href="/">Home</a> › <a href="/events">Events</a>
    <h1>Events</h1>
    {events && events.length !== 0 ? (
      events.map(event => (
        <div key={event.id}>
          <a href={`/events/${event.id}`}>
            <h1>{event.name}</h1>
          </a>
        </div>
      ))
    ) : (
      <h2>There are no events yet.</h2>
    )}
    <a href="/events/new">Add an event</a>
  </div>
)
