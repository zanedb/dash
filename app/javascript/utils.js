import moment from 'moment-timezone'

// get authenticity token, Rails security measure
// see: https://stackoverflow.com/a/1571900
export const getAuthenticityToken = () =>
  document.querySelector("head meta[name='csrf-token']").content.toString()

// normalize time strings with Moment.js
export const getTimeString = time =>
  moment(time)
    .tz(moment.tz.guess())
    .format('MMMM Do YYYY, h:mm:ss a z')
