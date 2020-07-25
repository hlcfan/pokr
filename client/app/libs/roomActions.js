import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'

export default {
  nextStory() {
    window.syncResult = false
    EventEmitter.dispatch("refreshUsers")
    EventEmitter.dispatch("refreshStories")
    EventEmitter.dispatch("resetActionBox")
  },

  showResultSection() {
    window.syncResult = true
    EventEmitter.dispatch("refreshUsers")
    EventEmitter.dispatch("refreshActionBox")
  }

}
