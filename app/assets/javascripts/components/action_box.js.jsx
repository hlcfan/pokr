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
  clearVotes: function() {
    if (POKER.role === 'Moderator') {
      App.rooms.perform('clear_votes', {
        roomId: POKER.roomId,
        data: { story_id: POKER.story_id }
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
    if (POKER.timer > 0) {
      clearInterval(POKER.timer);
    }
    $(".timer").show();
    $(".timer .counter").text(POKER.timerInterval);
    var tick = POKER.timerInterval;
    var $icon = $(".timer .fa");

    POKER.timer = setInterval(function() {
      if (tick <= 0) {
        if (!$icon.hasClass("warning")) {
          $(".timer .counter").text("Time up");
          $icon.attr("class", "fa warning").text("⚠️");
        }
        var $warning = $(".warning");
        if(!$warning.is(':animated')) {
          $warning.fadeToggle("fast");
        }
      } else {
        if (!$icon.hasClass("sandglass")) {
          $icon.attr("class", "fa sandglass").text("⌛").show();
        }
        tick -= 1;
        $(".timer .counter").text(tick);
      }
    }, 1000);
  },
  disableTimer: function() {
    $(".timer").remove();
  },
  componentDidMount: function() {
    EventEmitter.subscribe("resetActionBox", this.resetActionBox);
    EventEmitter.subscribe("roomClosed", this.setToDrawBoard);
    EventEmitter.subscribe("roomClosed", this.disableTimer);
    if (POKER.roomState !== "draw" && POKER.timerInterval > 0) {
      EventEmitter.subscribe("resetTimer", this.resetTimer);
      this.resetTimer();      
    }
    if (POKER.roomState === 'open') {
      showResultSection();
    }
  },
  render: function() {
    var that = this;
    var onClickName;
    var buttonText;
    var buttonHtml;
    var secondButtonText;
    var secondOnClickName;
    var buttonCount = 1;
    
    if (POKER.role === 'Moderator') {
      if (that.state.buttonState === 'not-open') {
        onClickName = that.showResult;
        buttonText = "Flip";
      } else if (that.state.buttonState === 'open') {
        onClickName = that.skipStory;
        buttonText = "Skip it";
        secondOnClickName = that.clearVotes;
        secondButtonText = "Clear votes"
        buttonCount = 2;
      } else if (that.state.buttonState === 'draw') {
        onClickName = that.showBoard;
        buttonText = "Show board";
      }
    }
    buttonHtml = (function() {
      if (onClickName && buttonText && buttonCount > 1) {
        return (
          <div className="btn-group btn-group-lg btn-group-justified" role="group">
            <a onClick={onClickName} className="btn btn-default btn-lg btn-info" href="javascript:;" role="button">
              {buttonText}
            </a>
            <a onClick={secondOnClickName} className="btn btn-default btn-lg btn-info" href="javascript:;" role="button">
              {secondButtonText}
            </a>
          </div>
        )
      } else if(onClickName && buttonText) {
        return (
          <div className="" role="group">
            <a onClick={onClickName} className="btn btn-default btn-lg btn-info btn-block" href="javascript:;" role="button">
              {buttonText}
            </a>
          </div>
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
        <div className="panel-heading">
          Action
          <span className="timer pull-right" style={{display: 'none'}}>
            <i className="fa sandglass">⌛</i>
            &nbsp;
            <i className="counter">{POKER.timerInterval}</i>
          </span>
        </div>
        <div className="panel-body row">
          <div id="actionBox" className="row">
            {tip}
            <ResultPanel />
            <div className="openButton container-fluid">
              {buttonHtml}
            </div>
          </div>
        </div>
      </div>
    );
  }
});