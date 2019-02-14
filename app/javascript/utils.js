import moment from 'moment-timezone'
import md5 from 'js-md5'

// get authenticity token, Rails security measure
// see: https://stackoverflow.com/a/1571900
export const getAuthenticityToken = () =>
  document.querySelector("head meta[name='csrf-token']").content.toString()

// normalize time strings with Moment.js
export const getTimeString = time =>
  moment(time)
    .tz(moment.tz.guess())
    .format('MMMM Do YYYY, h:mm:ss a z')

export const getAvatarUrl = (name, email) => {
  const separated = name.split(' ')
  const initials =
    separated.length === 2
      ? `${separated[0].charAt(0).toUpperCase()}${separated[1]
          .charAt(0)
          .toUpperCase()}`
      : name
  return `https://gravatar.com/avatar/${md5(
    email
  )}?s=96&d=https%3A%2F%2Fui-avatars.com%2Fapi%2F/${encodeURIComponent(
    initials
  )}/96/97a0ad/fff/2/0.4/false/true`
}
