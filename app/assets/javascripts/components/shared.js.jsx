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

function publishResult() {
  App.rooms.perform('action', {
    roomId: POKER.roomId,
    data: 'open',
    type: 'action'
  });

  if (POKER.role === 'Moderator' && POKER.roomState !== 'open') {
    $.ajax({
      url: '/rooms/' + POKER.roomId + '/set_room_status.json',
      data: { status: 'open' },
      method: 'post',
      dataType: 'json',
      cache: false,
      complete: function() {
        POKER.roomState = 'open';
      },
      error: function(xhr, status, err) {
        // pass
      }
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

function refreshStories() {
  App.rooms.perform('action', {
    roomId: POKER.roomId,
    data: 'refresh-stories',
    type: 'action'
  });
}

function refreshPeople() {
  App.rooms.perform('action', {
    roomId: POKER.roomId,
    data: 'refresh-people',
    type: 'action'
  });
}

function resetActionBox() {
  App.rooms.perform('action', {
    roomId: POKER.roomId,
    data: 'reset-action-box',
    type: 'action'
  });
}

function setupChannelSubscription() {
  // Subscribe to the public channel
  window.channelName =['rooms', POKER.roomId].join('/');
  App.rooms = App.cable.subscriptions.create({channel: 'RoomsChannel', room: POKER.roomId}, {
    connected: function(){
    },
    received: function(data) {
      console.dir(data);
      if (data.type === 'action') {
        if (data.data === 'open') {
          window.syncResult = true;
          showResultSection();
        } else if (data.data === 'refresh-stories') {
          window.syncResult = false;
          EventEmitter.dispatch("storySwitched");
        } else if (data.data === 'refresh-users') {
          if ($("#u-" + data.user_id).length <= 0) {
            EventEmitter.dispatch("refreshUsers");
          }
        }
      } else if(data.type === 'notify') {
        var $personElement = $('#u-' + data.person_id);
        if ($personElement.hasClass('voted')) {
          $personElement.removeClass("voted");
        }

        // TODO: read whether-should-show-point flag and decide show or not
        $('#u-' + data.person_id + ' .points').text(data.points);
        $('#u-' + data.person_id).attr('data-point', data.points);
        EventEmitter.dispatch("userListLoaded");
        setTimeout(function(){
          $personElement.addClass("voted", 100);
        }, 200);
      } else {

      }
    }
  });
}

function showResultSection() {
  $('#show-result').show();
  EventEmitter.dispatch("resultShown");
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
