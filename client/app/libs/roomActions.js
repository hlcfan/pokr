import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'

export default {
  nextStory() {
    window.syncResult = false;
    EventEmitter.dispatch("refreshUsers");
    EventEmitter.dispatch("refreshStories");
    EventEmitter.dispatch("resetActionBox");
  },

  showResultSection() {
    EventEmitter.dispatch("refreshUsers");
    EventEmitter.dispatch("showResultPanel");
  },

  revote() {
    nextStory();
    $('.vote-list ul li input').removeClass('disabled');
  }
}