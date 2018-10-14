//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require local-time
//= require jquery3

$(document).ready(function() {
  $(document).on('click', '[data-behavior~=flash_close]', function() {
    $(this)
      .parent()
      .fadeOut('fast')
  })
})
