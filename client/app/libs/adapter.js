import EventEmitter from 'libs/eventEmitter'
import RoomActions from 'libs/roomActions'
import ActionCable from 'actioncable'

let App = {}
const WsAdapter = {
  connect: (roomId) => {
    App.cable = ActionCable.createConsumer()

    App.rooms = App.cable.subscriptions.create({channel: 'RoomsChannel', room: roomId}, {
      connected: () => {
      },
      received: (data) => {
        handleMessage(data)
      }
    })
  },
  publish: (action, payload) => {
    App.rooms.perform(action, payload)
  }
}

const PollingAdapter = {
  connect: (roomId) => {
    MessageBus.start()
    MessageBus.callbackInterval = 500
    MessageBus.subscribe(`rooms/${roomId}`, function(data){
      handleMessage(data)
    })
  },
  publish: (action, payload) => {
    // console.dir(`Polling call: ${action}:${payload}`)
    $.ajax({
      url: `/rooms/${payload.roomId}/${action}.json`,
      method: 'POST',
      dataType: 'json',
      data: payload,
      cache: false,
      success: data => {
        // pass
      },
      error: (xhr, status, err) => {
        // pass
      }
    })
  }
}


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

let wsSupported = true
const Messenger = {
  connect: (roomId) => {
    if (window.WebSocket) {
      try {
        var websocket = new WebSocket( "wss://echo.websocket.org" )
        sleep(200).then(() => {
          if (websocket.readyState === 3) {
            wsSupported = false
          } else {
            wsSupported = true
          }
        })
      } catch ( e ) {
        wsSupported = false
      }
    } else {
      wsSupported = false
    }

    sleep(200).then(() => {
      if (wsSupported) {
        console.log("WebSocket supported!")
        WsAdapter.connect(roomId)
      } else {
        console.log("WebSocket not supported, switching to polling.")
        PollingAdapter.connect(roomId)
      }
    })
  },
  publish: (action, payload) => {
    if (wsSupported) {
      WsAdapter.publish(action, payload)
    } else {
      PollingAdapter.publish(action, payload)
    }
  }
}

function handleMessage(data) {
  // console.dir(data)
  if (data.type === 'action') {
    if (data.data === 'open') {
      RoomActions.showResultSection()
    } else if (data.data === 'refresh-users') {
      if ($("#u-" + data.user_id).length <= 0) {
        EventEmitter.dispatch("refreshUsers")
      }
    } else if(data.data === "next-story") {
      RoomActions.nextStory()
    } else if(data.data === "revote") {
      RoomActions.nextStory()
    } else if(data.data === "close-room") {
      EventEmitter.dispatch("roomClosed")
    } else if(data.data === "switch-roles") {
      EventEmitter.dispatch("refreshUsers")
    } else if(data.data === "clear-votes") {
      RoomActions.nextStory()
    }
  } else if(data.type === 'notify') {
    if (window.syncResult) {
      EventEmitter.dispatch("refreshUsers")
    }
    // Must keep for now
    var $personElement = $('#u-' + data.person_id)
    if ($personElement.hasClass('voted')) {
      $personElement.removeClass("voted")
    }
    setTimeout(function(){
      $personElement.addClass("voted", 100)
    }, 200)
  } else if(data.type === "evictUser") {
    EventEmitter.dispatch("evictUser", data.data.userId)
    EventEmitter.dispatch("refreshUsers")
  } else {
  }
}

module.exports = {
  Messenger: Messenger
}
