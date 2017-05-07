import React from 'react';
import Board from '../components/Board';
import ReactDOM from 'react-dom';
import EventEmitter from 'libs/eventEmitter';

var MODERATOR_ROLE = 0;
var PARTICIPANT_ROLE = 1;
var WATCHER_ROLE = 2;


window.pointEmojis = {
  "coffee": "☕",
  "?": "⁉️",
  "null" : "skipped"
}

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

window.setupChannelSubscription = function() {
  if (POKER.roomState === "draw") {
    return false;
  }
  App.rooms = App.cable.subscriptions.create({channel: 'RoomsChannel', room: POKER.roomId}, {
    connected: function(){
    },
    received: function(data) {
      // console.dir(data);
      if (data.type === 'action') {
        if (data.data === 'open') {
          window.syncResult = true;
          POKER.roomState = 'open';
          showResultSection();
        } else if (data.data === 'refresh-users') {
          if ($("#u-" + data.user_id).length <= 0) {
            EventEmitter.dispatch("refreshUsers");
          }
        } else if(data.data === "next-story") {
          nextStory();
        } else if(data.data === "revote") {
          revote();
        } else if(data.data === "close-room") {
          EventEmitter.dispatch("roomClosed");
        } else if(data.data === "switch-roles") {
          EventEmitter.dispatch("refreshUsers");
        } else if(data.data === "clear-votes") {
          nextStory();
        }
      } else if(data.type === 'notify') {
        var $personElement = $('#u-' + data.person_id);
        if ($personElement.hasClass('voted')) {
          $personElement.removeClass("voted");
        }
        setTimeout(function(){
          $personElement.addClass("voted", 100);
        }, 200);

        window.syncResult = data.sync;
        if (syncResult) {
          $('#u-' + data.person_id + ' .points').text(pointEmojis[data.points] || data.points);
          $('#u-' + data.person_id).attr('data-point', data.points);
        }
        EventEmitter.dispatch("showResultPanel");
      } else {

      }
    }
  });
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
