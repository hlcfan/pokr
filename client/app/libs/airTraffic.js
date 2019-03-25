import { WsAdapter, PollingAdapter } from 'libs/adapter'

export default {
  setupChannelSubscription(roomId) {
    let wsSupported
    if (window.WebSocket) {
      try {
        var websocket = new WebSocket( "wss://echo.websocket.org" )
        wsSupported = true
      } catch ( e ) {
        wsSupported = false
      }
    } else {
      wsSupported = false
    }

    if (wsSupported) {
      WsAdapter.connect(roomId)
    } else {
      PollingAdapter.connect(roomId)
    }
    console.log("WS supported!")
  }
}
