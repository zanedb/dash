import React from 'react'
import 'unfetch/polyfill'
import qs from 'qs'
import { getAuthenticityToken } from '../../../utils'

export default ({ attendee, event }) => {
  const deleteAttendee = () => {
    const csrfToken = getAuthenticityToken()
    const deleteConfirm = confirm(
      'Are you sure you want to delete this attendee?'
    )
    if (deleteConfirm) {
      fetch(`/events/${event.id}/attendees/${attendee.id}`, {
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

  return (
    <div>
      <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
      <a href={`/events/${event.id}`}>{event.name}</a> ›{' '}
      <a href={`/events/${event.id}/attendees`}>Attendees</a> ›{' '}
      <a href="#">
        {attendee.fname} {attendee.lname}
      </a>
      <h1>
        {attendee.fname} {attendee.lname}
      </h1>
      <h2>
        Event: <a href={`/events/${event.id}`}>{event.name}</a>
      </h2>
      <h4>
        Email: <a href={`mailto:${attendee.email}`}>{attendee.email}</a>
      </h4>
      <h4>
        Notes:
        <br />
        {attendee.note}
      </h4>
      <a href={`/events/${event.id}/attendees/${attendee.id}/edit`}>
        Edit attendee
      </a>
      <button onClick={deleteAttendee}>Delete attendee</button>
    </div>
  )
}
