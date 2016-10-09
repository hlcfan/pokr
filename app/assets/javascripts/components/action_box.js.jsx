var ActionBox = React.createClass({
  getInitialState: function() {
    return { buttonState: POKER.roomState };
  },
  showResult: function(e) {
    this.setState({buttonState: 'open'});
    if (!Cookies.get('showTip')) {
      Cookies.set('showTip', true);
    }
    publishResult();
  },
  skipStory: function() {
    if (POKER.role === 'Moderator') {
      App.rooms.perform('set_story_point', {
        roomId: POKER.roomId,
        data: { point: 'null', story_id: POKER.story_id }
      });
    }
  },
  resetActionBox: function() {
    this.setState({ buttonState: 'not-open' });
  },
  setToDrawBoard: function() {
    this.setState({ buttonState: 'draw' });
  },
  showBoard: function() {
    $('#board').html('');
    drawBoard();
  },
  resetTimer: function() {
    if (!$.isEmptyObject(POKER.timer)) {
      clearInterval(POKER.timer);
    }

    $(".timer").text(POKER.timerInterval);
    var tick = POKER.timerInterval;
    POKER.timer = setInterval(function() {
      tick -= 1;
      $(".timer").text(tick);
    },1000);
  },
  componentDidMount: function() {
    EventEmitter.subscribe("resetActionBox", this.resetActionBox);
    EventEmitter.subscribe("noStoriesLeft", this.setToDrawBoard);
    EventEmitter.subscribe("resetTimer", this.resetTimer);
    this.resetTimer();
    if (POKER.roomState === 'open') {
      showResultSection();
    }
  },
  componentDidUpdate: function() {
    EventEmitter.subscribe("noStoriesLeft", this.setToDrawBoard);
  },
  render: function() {
    var that = this;
    var onClickName;
    var buttonText;
    var buttonHtml;
    
    if (POKER.role === 'Moderator') {
      if (that.state.buttonState === 'not-open') {
        onClickName = that.showResult;
        buttonText = "Flip";
      } else if (that.state.buttonState === 'open') {
        onClickName = that.skipStory;
        buttonText = "Skip it";
      } else if (that.state.buttonState === 'draw') {
        onClickName = that.showBoard;
        buttonText = "Show board";
      }
    }
    buttonHtml = (function() {
      if (onClickName && buttonText) {
        return (
          <a onClick={onClickName} className="btn btn-default btn-lg btn-info btn-block" href="javascript:;" role="button">
            {buttonText}
          </a>
        )
      }
    })();
    var tip = (function(){
      // already decided point
      if (Cookies.get('showTip') && !Cookies.get('adp') && POKER.role === 'Moderator') {
        Cookies.set('adp', true);
        return (
          <div className="container-fluid" style={{clear: 'both', width: '90%'}}>
            <div className="alert alert-success alert-dismissible" role="alert">
              <button type="button" className="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <strong>Tip!</strong> Click the bar below to decide the point.
            </div>
          </div>
        )
      }
    })();

    return (
      <div className="panel panel-default">
        <div className="panel-heading">Action<span className="timer pull-right">{POKER.timerInterval}</span></div>
        <div className="panel-body row">
          <div id="actionBox" className="row">
            {tip}
            <ResultPanel />
            <div ref="openButton" className="openButton container-fluid">
              <div className="">
                {buttonHtml}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});