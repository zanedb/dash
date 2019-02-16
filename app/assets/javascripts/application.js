//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require local-time
//= require jquery3
//= require Chart.bundle
//= require chartkick

$(document).ready(function() {
  // open & then close flash message a bit later
  if ($('.flash').length) {
    $('.flash')
      .hide()
      .delay(250)
      .slideDown()
      .delay(4000)
      .slideUp()
  }
  $('.flash').click(function() {
    $('.flash')
      .clearQueue()
      .slideUp()
  })

  /* BEGIN DROPDOWN CODE */
  $(document).on('click', '[data-behavior~=dropdown_trigger]', function() {
    // this workaround allows one dropdown opening to close the other
    const wasHidden = $(this)
      .parents('.dropdown')
      .children('.dropdown__content')
      .is(':hidden')
    $('.dropdown__content').slideUp('fast')
    $('.dropdown__btn').attr('aria-expanded', 'false')
    if (wasHidden) {
      $(this)
        .parents('.dropdown')
        .children('.dropdown__content')
        .slideDown('fast')
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
      $('.dropdown__content').slideUp('fast')
      $('.dropdown__btn').attr('aria-expanded', 'false')
    }
  })
  $(document).keydown(e => {
    // close dropdown on esc key press
    if (e.keyCode === 27) {
      $('.dropdown__content').slideUp('fast')
      $('.dropdown__btn').attr('aria-expanded', 'false')
    }
  })
  /* END DROPDOWN CODE */
})
