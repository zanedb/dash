import React from 'react'
import 'unfetch/polyfill'
import qs from 'qs'
import { getAuthenticityToken } from '../utils'

export default ({ event }) => {
  const deleteEvent = () => {
    const csrfToken = getAuthenticityToken()
    const deleteConfirm = confirm('Are you sure you want to delete this event?')
    if (deleteConfirm) {
      fetch(`/events/${event.id}`, {
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

  const startDate = new Date(event.startDate)
  const endDate = new Date(event.endDate)

  return (
    <div>
      <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
      <a href="#">{event.name}</a>
      <h1>{event.name}</h1>
      <h3>
        Starts at: {startDate.toDateString()}, {startDate.toTimeString()}
      </h3>
      <h3>
        Ends at: {endDate.toDateString()}, {endDate.toTimeString()}
      </h3>
      <h4>
        Takes place at:
        <br />
        {event.location}
      </h4>
      <a href={`/events/${event.id}/edit`}>Edit event</a>
      <button onClick={deleteEvent}>Delete event</button>
    </div>
  )
}
