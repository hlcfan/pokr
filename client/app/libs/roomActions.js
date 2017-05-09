import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'

export default {
  nextStory() {
    window.syncResult = false;
    EventEmitter.dispatch("refreshUsers");
    EventEmitter.dispatch("refreshStories");
    EventEmitter.dispatch("resetActionBox");
    if (POKER.timerInterval > 0) {
      EventEmitter.dispatch("resetTimer");
    }
  },

  showResultSection() {
    EventEmitter.dispatch("refreshUsers");
    EventEmitter.dispatch("showResultPanel");
  }
}