import { Messenger } from 'libs/adapter'

export default {
  setupChannelSubscription(roomId) {
    window.Messenger = Messenger
    window.Messenger.connect(roomId)
  }
}
