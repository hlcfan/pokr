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

document.addEventListener('DOMContentLoaded', () => {
  roomId = document.querySelector("#roomId").value
  roomName = document.querySelector("#roomName").value
  role = document.querySelector("#role").value
  currentVote = document.querySelector("#currentVote").value
  roomState = document.querySelector("#roomState").value
  pointValues = JSON.parse(document.querySelector("#pointValues").value)
  timerInterval = document.querySelector("#timerInterval").value
  freeStyle = document.querySelector("#freeStyle").value
  currentStoryId = document.querySelector("#currentStoryId").value
  currentUserId = document.querySelector("#currentUserId").value
  duration = parseInt(document.querySelector("#duration").value)
  const roomApp = document.querySelector('#room')

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
})
