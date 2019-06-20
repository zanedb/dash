//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require local-time
//= require jquery3
//= require highcharts
//= require chartkick

Highcharts.setOptions({
  chart: {
    style: {
      fontFamily: `'ProximaNova', system-ui, -apple-system, Roboto, sans-serif`
    }
  },
  colors: ['#0069ff']
})

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

const setAppearance = status => {
  if (status === 'dark') {
    $('html').removeClass('dark')
    $('html').addClass('dark')
    $('.dark-mode-off').hide()
    $('.dark-mode-on').show()
  } else if (status === 'light') {
    $('html').removeClass('dark')
    $('.dark-mode-on').hide()
    $('.dark-mode-off').show()
  }
  updateLS()
}
// listen for OS dark mode toggled (on Apple devices)
const mqlDark = window.matchMedia('(prefers-color-scheme: dark)')
const mqlLight = window.matchMedia('(prefers-color-scheme: light)')
mqlDark.addListener(e => setAppearance(e.matches ? 'dark' : 'light'))
// toggle appearance between light and dark
const toggleAppearance = () => {
  $('html').toggleClass('dark')
  $('.dark-mode-off').toggle()
  $('.dark-mode-on').toggle()
  updateLS()
}
// update local storage value
const updateLS = () =>
  localStorage.setItem(
    'appearance',
    $('html').hasClass('dark') ? 'dark' : 'light'
  )

$(document).ready(function() {
  // load appearance
  if (localStorage.getItem('appearance')) {
    setAppearance(localStorage.getItem('appearance'))
  } else if (mqlDark.matches === true) {
    setAppearance('dark')
  } else if (mqlLight.matches === true) {
    setAppearance('light')
  } else {
    setAppearance('light')
  }

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
})

$(document).on('turbolinks:load', () => {
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
    records.each(function() {
      if (valid(this)) $(this).show()
    })
  }

  // patch for keyboard accessibility: simulate click on enter key
  $(document).on('keyup', '[data-behavior~=filterbar__item]', e => {
    if (e.keyCode === 13) $(e.target).click()
  })

  $(document).on('click', '[data-behavior~=filterbar__item]', e => {
    const name = $(e.target).data('name') || 'exists'
    activateFilterItem(name)
    filterRecords(record => {
      const data = $(record).data('filter')
      return data[name] // returns true/false from currentFilter record in data-filter
    })
  })

  $(document).on('input', '[data-behavior~=filterbar__search]', e => {
    if (currentFilter() !== 'exists') activateFilterItem('exists')
    const value = $(e.target)
      .val()
      .toLowerCase()
    filterRecords(
      record =>
        $(record)
          .data('name')
          .toLowerCase()
          .indexOf(value) > -1
    )
  })

  // remember login email
  $(document).on('submit', '[data-behavior~=remember_email]', () => {
    localStorage.setItem('login_email', $('input[type=email]').val())
  })
  elementIsThere('remember_email') &&
    (loginEmail = localStorage.getItem('login_email')) &&
    selectByBehavior('remember_email')
      .find('input[type=email]')
      .val(loginEmail)

  $(document).on('click', '[data-behavior~=dark-mode-toggle]', () => {
    toggleAppearance()
  })
})
