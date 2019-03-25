import Messenger from 'libs/adapter'

export default {
  setupChannelSubscription(roomId) {
    Messenger.connect(roomId)
  }
}
