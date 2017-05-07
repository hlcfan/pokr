import React from 'react'
import Board from '../components/Board'
import ReactDOM from 'react-dom'
import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'

var MODERATOR_ROLE = 0;
var PARTICIPANT_ROLE = 1;
var WATCHER_ROLE = 2;

window.publishResult = function() {
  if (POKER.role === 'Moderator' && POKER.roomState !== 'open') {
    App.rooms.perform('action', {
      roomId: POKER.roomId,
      data: 'open',
      type: 'action'
    });
  }
}

window.notifyVoted = function() {
  App.rooms.perform('action', {
    roomId: POKER.roomId,
    data: POKER.currentUser.name,
    type: 'notify'
  });
}

window.nextStory = function() {
  window.syncResult = false;
  POKER.roomState = "not-open"
  EventEmitter.dispatch("refreshUsers");
  EventEmitter.dispatch("refreshStories");
  EventEmitter.dispatch("resetActionBox");
  if (POKER.timerInterval > 0) {
    EventEmitter.dispatch("resetTimer");
  }
}

window.revote = function() {
  nextStory();
  $('.vote-list ul li input').removeClass('disabled');
}


window.showResultSection = function() {
  $('#show-result').show();
  EventEmitter.dispatch("refreshUsers");
  EventEmitter.dispatch("showResultPanel");
}

window.drawBoard = function () {
  $.ajax({
    url: '/rooms/' + POKER.roomId + '/set_room_status.json',
    data: { status: 'draw' },
    method: 'post',
    dataType: 'json',
    cache: false,
    success: function(data) {
      // pass
    },
    error: function(xhr, status, err) {
      // pass
    }
  });
  var drawBoardUrl = '/rooms/' + POKER.roomId + '/draw_board.json';
  ReactOnRails.render("Board", {url: drawBoardUrl}, 'board');
}
