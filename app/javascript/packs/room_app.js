/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add  to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
// import * as ActiveStorage from "@rails/activestorage"
// import "channels"

// Rails.start()
// Turbolinks.start()
// ActiveStorage.start()

import ReactDOM from 'react-dom'
import React from 'react'
import Room from './bundles/Room/containers/Room'
import RoomMobile from './bundles/Room/containers/RoomMobile'
import * as Sentry from "@sentry/react"
import { Integrations } from "@sentry/tracing"

Sentry.init({
  dsn: "https://e1070f75c7b24052a1784b4ce297b9e2@o100957.ingest.sentry.io/221730",
  release: "my-project-name@" + process.env.npm_package_version,
  integrations: [new Integrations.BrowserTracing()],

  // We recommend adjusting this value in production, or using tracesSampler
  // for finer control
  tracesSampleRate: 1.0,
});

document.addEventListener('DOMContentLoaded', () => {
  const roomId = document.querySelector("#roomId").value
  const roomName = document.querySelector("#roomName").value
  const role = document.querySelector("#role").value
  const currentVote = document.querySelector("#currentVote").value
  const roomState = document.querySelector("#roomState").value
  const pointValues = JSON.parse(document.querySelector("#pointValues").value)
  const timerInterval = document.querySelector("#timerInterval").value
  const freeStyle = document.querySelector("#freeStyle").value
  const currentStoryId = document.querySelector("#currentStoryId").value
  const currentUserId = document.querySelector("#currentUserId").value
  const duration = parseInt(document.querySelector("#duration").value)
  const roomApp = document.querySelector('#room')
  const isMobileRequest = document.querySelector('#isMobileRequest')

  if (isMobileRequest === "true") {
    ReactDOM.render(
      <RoomMobile roomId= { roomId }
        roomName={ roomName }
        currentUserId= { currentUserId }
        role= { role }
        roomState= { roomState }
        pointValues= { pointValues }
        timerInterval= { timerInterval }
        freeStyle= { freeStyle }
        storyListUrl= { "/rooms/"+roomId+"/story_list.json" }
        peopleListUrl= { "/rooms/"+roomId+"/user_list.json" }
        currentVote= { currentVote }
        currentStoryId= { currentStoryId }
        duration= { duration } />,
      roomApp
    )
  } else {
    ReactDOM.render(
      <Room roomId= { roomId }
        roomName={ roomName }
        currentUserId= { currentUserId }
        role= { role }
        roomState= { roomState }
        pointValues= { pointValues }
        timerInterval= { timerInterval }
        freeStyle= { freeStyle }
        storyListUrl= { "/rooms/"+roomId+"/story_list.json" }
        peopleListUrl= { "/rooms/"+roomId+"/user_list.json" }
        currentVote= { currentVote }
        currentStoryId= { currentStoryId }
        duration= { duration } />,
      roomApp
    )
  }

})
