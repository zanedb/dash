import React from 'react'
import 'unfetch/polyfill'
import qs from 'qs'
import { getAuthenticityToken, getTimeString } from '../../utils'

export default ({ event }) => {
  const deleteEvent = () => {
    const csrfToken = getAuthenticityToken()
    const deleteConfirm = confirm('Are you sure you want to delete this event?')
    if (deleteConfirm) {
      fetch(`/events/${event.slug}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: qs.stringify({
          authenticity_token: csrfToken,
          _method: 'delete'
        })
      }).then(res => {
        window.location.href = res.url
      })
    }
  }

  const startDate = getTimeString(event.startDate)
  const endDate = getTimeString(event.endDate)

  return (
    <div>
      <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
      <a href="#">{event.name}</a>
      <h1>{event.name}</h1>
      <h3>Starts at: {startDate}</h3>
      <h3>Ends at: {endDate}</h3>
      <h4 style={{ whiteSpace: 'pre-line' }}>
        Takes place at:
        <br />
        <a
          href={`https://www.google.com/maps?q=${encodeURIComponent(
            event.location
          )}`}
          target="_blank"
          rel="noopen noreferrer"
        >
          {event.location}
        </a>
      </h4>
      <a href={`/events/${event.slug}/edit`}>Edit event</a>
      <button onClick={deleteEvent}>Delete event</button>
      <br />
      <a href={`/events/${event.slug}/attendees`}>View attendees</a>
    </div>
  )
}
