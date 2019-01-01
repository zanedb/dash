//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require local-time
//= require jquery3

$(document).ready(function() {
  // close flash message on click
  $(document).on('click', '[data-behavior~=flash_close]', function() {
    $(this)
      .parent()
      .fadeOut('fast')
  })
  // dropdown code
  $(document).on('click', '[data-behavior~=dropdown_trigger]', function() {
    // toggle dropdown on profile icon click
    $('.dropdown__content').toggle()
    // toggle aria-expanded attribute
    $('.dropdown__btn').attr('aria-expanded') === 'true'
      ? $('.dropdown__btn').attr('aria-expanded', 'false')
      : $('.dropdown__btn').attr('aria-expanded', 'true')
  })
  $(document).on('click', e => {
    // close dropdown on click outside of dropdown
    if ($(e.target).parent()[0] !== $('.dropdown__btn')[0]) {
      $('.dropdown__content').hide()
      $('.dropdown__btn').attr('aria-expanded', 'false')
    }
  })
  $(document).keydown(e => {
    // close dropdown on esc key press
    if (
      e.keyCode === 27 &&
      $('.dropdown__btn').attr('aria-expanded') === 'true'
    ) {
      $('.dropdown__content').hide()
      $('.dropdown__btn').attr('aria-expanded', 'false')
    }
  })
})
