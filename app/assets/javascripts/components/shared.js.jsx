var EventEmitter = {
  _events: {},
  dispatch: function (event, data) {
    if (!this._events[event]) {
      return;
    }
    for (var i = 0; i < this._events[event].length; i++) {
      this._events[event][i](data);
    }
  },
  subscribe: function (event, callback) {
    if (!this._events[event]) {
      this._events[event] = [];
    }
    this._events[event].push(callback);
  }
};

var barColors = [
  "#000532",
  "#376182",
  "#5e6370",
  "#a4a0a2",
  "#ff4265",
  "#07adeb",
  "#acdfe8",
  "#78bac2",
  "#b4eeb4",
  "#cbf3ad",
  "#ffc0cb",
  "#ffe4e1"
];

var pointEmojis = {
  "coffee": "☕",
  "?": "⁉️"
}

function publishResult() {
  if (POKER.role === 'Moderator' && POKER.roomState !== 'open') {
    App.rooms.perform('action', {
      roomId: POKER.roomId,
      data: 'open',
      type: 'action'
    });
  }
}

function notifyVoted() {
  App.rooms.perform('action', {
    roomId: POKER.roomId,
    data: POKER.currentUser.name,
    type: 'notify'
  });
}

function nextStory() {
  window.syncResult = false;
  POKER.roomState = "not-open"
  EventEmitter.dispatch("refreshUsers");
  EventEmitter.dispatch("refreshStories");
  EventEmitter.dispatch("resetActionBox");
}

function setupChannelSubscription() {
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

function showResultSection() {
  $('#show-result').show();
  EventEmitter.dispatch("refreshUsers");
  EventEmitter.dispatch("showResultPanel");
}

function drawBoard() {
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
  ReactDOM.render(
    <Board url={drawBoardUrl} />,
    document.getElementById('board')
  );
}
