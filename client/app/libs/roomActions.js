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
  },

  flip() {
    window.syncResult = true
    EventEmitter.dispatch("refreshUsers", true)
  },

  revote() {
    nextStory();
    $('.vote-list ul li input').removeClass('disabled')
  }
}