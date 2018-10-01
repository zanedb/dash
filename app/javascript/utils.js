// get authenticity token, Rails security measure
// see: https://stackoverflow.com/a/1571900
export const getAuthenticityToken = () =>
  document.querySelector("head meta[name='csrf-token']").content.toString()
