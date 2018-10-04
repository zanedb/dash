/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import React from 'react'
import ReactDOM from 'react-dom'

import Turbolinks from 'turbolinks'
Turbolinks.start()

import WebpackerReact from 'webpacker-react'
import Home from '../pages/Home'
// events
import Events from '../pages/Events'
import Event from '../pages/event/Event'
import EventsNew from '../pages/event/New'
import EventsEdit from '../pages/event/Edit'
// attendees
import Attendees from '../pages/event/Attendees'
import Attendee from '../pages/event/attendee/Attendee'
import AttendeesNew from '../pages/event/attendee/New'
import AttendeesEdit from '../pages/event/attendee/Edit'

WebpackerReact.setup({
  Home,
  Events,
  Event,
  EventsNew,
  EventsEdit,
  Attendees,
  Attendee,
  AttendeesNew,
  AttendeesEdit
})
