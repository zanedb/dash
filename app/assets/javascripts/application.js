//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require local-time
//= require jquery3
//= require Chart.bundle
//= require chartkick

$(document).ready(function() {
  // close flash message on click
  $(document).on('click', '[data-behavior~=flash_close]', function() {
    $(this)
      .parent()
      .fadeOut('fast')
  })

  /* BEGIN DROPDOWN CODE */
  $(document).on('click', '[data-behavior~=dropdown_trigger]', function() {
    // this workaround allows one dropdown opening to close the other
    const wasHidden = $(this)
      .parents('.dropdown')
      .children('.dropdown__content')
      .is(':hidden')
    $('.dropdown__content').hide()
    $('.dropdown__btn').attr('aria-expanded', 'false')
    if (wasHidden) {
      $(this)
        .parents('.dropdown')
        .children('.dropdown__content')
        .show()
      $(this).attr('aria-expanded', 'true')
    }
  })
  $(document).on('click', e => {
    // close dropdown on click outside of dropdown
    if (
      !$(e.target)
        .parents()
        .hasClass('dropdown__btn')
    ) {
      $('.dropdown__content').hide()
      $('.dropdown__btn').attr('aria-expanded', 'false')
    }
  })
  $(document).keydown(e => {
    // close dropdown on esc key press
    if (e.keyCode === 27) {
      $('.dropdown__content').hide()
      $('.dropdown__btn').attr('aria-expanded', 'false')
    }
  })
  /* END DROPDOWN CODE */
})
