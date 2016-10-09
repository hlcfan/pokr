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
    if (POKER.timer > 0) {
      clearInterval(POKER.timer);
    }
    $(".timer").show();
    $(".timer .counter").text(POKER.timerInterval);
    var tick = POKER.timerInterval;
    POKER.timer = setInterval(function() {
      var $icon = $(".timer .fa");
      if (tick <= 0) {
        if (!$icon.hasClass("fa-bell-o")) {
          $(".timer .counter").text("Time up");
          $icon.attr("class", "fa fa-bell-o");
        }
        $icon.animate({
          'font-size': '8px'
        }, 500, "swing", function() {
          $(this).animate({
            'font-size': '16px'
          }, 500)
        });
      } else {
        if (!$icon.hasClass("fa-clock-o")) {
          $icon.attr("class", "fa fa-clock-o")
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
    EventEmitter.subscribe("noStoriesLeft", this.setToDrawBoard);
    EventEmitter.subscribe("noStoriesLeft", this.disableTimer);
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
        <div className="panel-heading">
          Action
          <span className="timer pull-right" style={{display: 'none'}}>
            <i className="fa fa-clock-o"></i>
            &nbsp;
            <i className="counter">{POKER.timerInterval}</i>
          </span>
        </div>
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