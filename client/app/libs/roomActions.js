import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'

export default {
  nextStory() {
    window.syncResult = false;
    // POKER.roomState = "not-open"
    EventEmitter.dispatch("refreshUsers");
    EventEmitter.dispatch("refreshStories");
    EventEmitter.dispatch("resetActionBox");
    if (POKER.timerInterval > 0) {
      EventEmitter.dispatch("resetTimer");
    }
  }
}