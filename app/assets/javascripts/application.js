//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require local-time
//= require jquery3
//= require Chart.bundle
//= require chartkick

// selectByBehavior('some_behavior') is a shortcut for selecting elements by data-behavior
const selectByBehavior = (selector, filter = '') =>
  $(`[data-behavior~=${selector}]`).filter(
    filter.length > 0 ? filter : () => true
  )
const elementIsNotThere = (selector, filter) =>
  selectByBehavior(selector, filter).is(':empty')
const elementIsThere = (selector, filter) =>
  !elementIsNotThere(selector, filter)

const deselectElement = (selector, filter = '[aria-selected=true]') =>
  selectByBehavior(selector, filter).attr('aria-selected', false)
const selectElement = (selector, filter) =>
  selectByBehavior(selector, filter).attr('aria-selected', true)

$(document).on('turbolinks:load', function() {
  // open & then close flash message a bit later
  if ($('.flash').length) {
    $('.flash')
      .hide()
      .delay(250)
      .slideDown()
      .delay(3000)
      .slideUp()
  }
  $('.flash').click(function() {
    $('.flash')
      .clearQueue()
      .slideUp()
  })

  // dropdown
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

  // filter/search helpers & code
  const currentFilter = () =>
    selectByBehavior('filterbar__item', '[aria-selected=true]').data('name')

  const findFilterItem = name =>
    selectByBehavior('filterbar__item', `[data-name=${name}]`)

  const activateFilterItem = name => {
    deselectElement('filterbar__item')
    selectElement('filterbar__item', `[data-name=${name}]`)
  }

  if (elementIsThere('filterbar__filters')) activateFilterItem('exists')

  // pass in function for each record
  const filterRecords = valid => {
    const records = selectByBehavior('filterbar__row').hide()
    console.log(records)
    records.each(record => {
      if (valid(record)) $(record).show()
    })
  }

  // patch for keyboard accessibility: simulate click on enter key
  $(document).on('keyup', '[data-behavior~=filterbar__item]', e => {
    if (e.keyCode === 13) $(e.target).click()
  })

  $(document).on('click', '[data-behavior~=filterbar__item]', () => {
    const name = $(this).data('name') || 'exists'
    activateFilterItem(name)
    filterRecords(record => {
      const data = $(record).data('filter')
      console.log(data) // returns undefined, should return json
      console.log(record) // returns 0, should return record
      return data[name] // returns undefined, should return true/false from currentFilter record in data-filter
    })
  })

  $(document).on('input', '[data-behavior~=filterbar__search]', () => {
    if (currentFilter() !== 'exists') activateFilterItem('exists')
    const value = $(this)
      .val()
      .toLowerCase()
    filterRecords(
      record =>
        $(record)
          .text()
          .toLowerCase()
          .indexOf(value) > -1
    )
  })

  // remember login email
  $(document).on('submit', '[data-behavior~=login]', () => {
    localStorage.setItem('login_email', $('input[type=email]').val())
  })
  elementIsThere('login') &&
    (loginEmail = localStorage.getItem('login_email')) &&
    selectByBehavior('login')
      .find('input[type=email]')
      .val(loginEmail)
})
