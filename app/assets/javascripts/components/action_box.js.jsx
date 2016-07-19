var ActionBox = React.createClass({
  getInitialState: function() {
    return { buttonState: POKER.roomState };
  },
  showResult: function(e) {
    this.setState({buttonState: 'open'});
    publishResult();
  },
  skipStory: function() {
    if (POKER.role === 'Owner') {
      $.ajax({
        url: '/rooms/' + POKER.roomId + '/set_story_point.json',
        data: { point: 'null', story_id: POKER.story_id },
        method: 'post',
        dataType: 'json',
        cache: false,
        success: function(data) {
          refreshStories();
          refreshPeople();
          resetActionBox();
        },
        error: function(xhr, status, err) {
          console.error(status, err.toString());
        }
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
  componentDidMount: function() {
    EventEmitter.subscribe("storySwitched", this.resetActionBox);
    EventEmitter.subscribe("noStoriesLeft", this.setToDrawBoard);
    if (POKER.roomState === 'open') {
      showResultSection();
    }
  },
  componentDidUpdate: function() {
    EventEmitter.subscribe("noStoriesLeft", this.setToDrawBoard);
  },
  render: function() {
    var that = this;
    var actionButton = (function() {
      if (POKER.role === 'Owner') {
        if (that.state.buttonState === 'not-open') {
          return (
            <a onClick={that.showResult} className="btn btn-default btn-lg btn-success btn-block" href="javascript:;" role="button">
              开？
            </a>
          );
        } else if (that.state.buttonState === 'open') {
          return (
            <a onClick={that.skipStory} className="btn btn-default btn-lg btn-success btn-block" href="javascript:;" role="button">
              Skip it
            </a>
          );
        } else if (that.state.buttonState === 'draw') {
          return (
            <a onClick={that.showBoard} className="btn btn-default btn-lg btn-success btn-block" href="javascript:;" role="button">
              Show board
            </a>
          );
        }
      }
    })();

    return (
      <div className="panel panel-default">
        <div className="panel-heading">Action</div>
        <div className="panel-body row">
          <div id="actionBox" className="row">
            <ResultPanel />
            <div ref="openButton" className="openButton container-fluid">
              <div className="">
                {actionButton}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});