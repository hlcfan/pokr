import React from 'react'
import Board from '../components/Board'
import ReactDOM from 'react-dom'
import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'

var MODERATOR_ROLE = 0;
var PARTICIPANT_ROLE = 1;
var WATCHER_ROLE = 2;

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
