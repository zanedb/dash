import React from 'react'

export default ({ attendees, event }) => (
  <div>
    <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
    <a href={`/events/${event.id}`}>{event.name}</a> › <a href="#">Attendees</a>
    <h1>
      Attendees: <b>{event.name}</b>
    </h1>
    {attendees && attendees.length !== 0 ? (
      <ul>
        {attendees.map(attendee => (
          <li key={attendee.id}>
            <a href={`/events/${event.id}/attendees/${attendee.id}`}>
              {attendee.fname} {attendee.lname}
            </a>
          </li>
        ))}
      </ul>
    ) : (
      <h2>There are no attendees yet.</h2>
    )}
    <a href={`/events/${event.id}/attendees/new`}>Add an attendee</a>
  </div>
)
