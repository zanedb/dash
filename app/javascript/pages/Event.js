import React from 'react'
import axios from 'axios'
import qs from 'qs'

export default ({ event }) => {
  const deleteEvent = () => {
    // get authenticity token, Rails security measure
    // see: https://stackoverflow.com/a/1571900
    const csrfToken = document
      .querySelector("head meta[name='csrf-token']")
      .content.toString()
    const deleteConfirm = confirm('Are you sure you want to delete this event?')
    if (deleteConfirm) {
      axios({
        url: `/events/${event.id}`,
        method: 'post',
        data: qs.stringify({
          authenticity_token: csrfToken,
          _method: 'delete'
        })
      }).then(res => {
        window.location.href = res.request.responseURL
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
