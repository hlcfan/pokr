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
      $.ajax({
        url: '/rooms/' + POKER.roomId + '/set_story_point.json',
        data: { point: 'null', story_id: POKER.story_id },
        method: 'post',
        dataType: 'json',
        cache: false,
        success: function(data) {
          refreshStories();
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
    EventEmitter.subscribe("resetActionBox", this.resetActionBox);
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
      if (POKER.role === 'Moderator') {
        if (that.state.buttonState === 'not-open') {
          return (
            <a onClick={that.showResult} className="btn btn-default btn-lg btn-success btn-block" href="javascript:;" role="button">
              开
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
        <div className="panel-heading">Action</div>
        <div className="panel-body row">
          <div id="actionBox" className="row">
            {tip}
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