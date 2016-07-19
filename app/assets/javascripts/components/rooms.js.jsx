var EventEmitter = {
  _events: {},
  dispatch: function (event, data) {
      if (!this._events[event]) { // 没有监听事件
        return;
      }
      for (var i = 0; i < this._events[event].length; i++) {
          this._events[event][i](data);
      }
  },
  subscribe: function (event, callback) {
    // 创建一个新事件数组
    if (!this._events[event]) {
      this._events[event] = [];
    }
    this._events[event].push(callback);
  }
};

function publishResult() {
  client.publish(channelName, {
    data: 'open',
    type: 'action'
  });

  if (POKER.role === 'Owner' && POKER.roomState !== 'open') {
    $.ajax({
      url: '/rooms/' + POKER.roomId + '/set_room_status.json',
      data: { status: 'open' },
      method: 'post',
      dataType: 'json',
      cache: false,
      complete: function() {
        POKER.roomState = 'open';
      },
      error: function(xhr, status, err) {
        // pass
      }
    });
  }
}

function notifyVoted() {
  client.publish(channelName, {
    data: POKER.currentUser.name,
    type: 'notify'
  });
}

function refreshStories() {
  client.publish(channelName, {
    data: 'refresh-stories',
    type: 'action'
  });
}

function refreshPeople() {
  client.publish(channelName, {
    data: 'refresh-people',
    type: 'action'
  });
}

function resetActionBox() {
  client.publish(channelName, {
    data: 'reset-action-box',
    type: 'action'
  });
}

var StatusBar = React.createClass({
  render:function(){
    return (
      <h3>
        {POKER.roomName}
        <i className="pull-right">Yo, {POKER.currentUser.name}({POKER.role})!</i>
      </h3>
    );
  }
});

var VoteBox = React.createClass({
  onItemClick: function(e) {
    var node = $(e.target);
    if (POKER.story_id) {
      // Remove all selected points
      $('.vote-list ul li input').removeClass('btn-info');
      node.toggleClass('btn-info');
      $.ajax({
        url: '/rooms/' + POKER.roomId + '/vote.json',
        data: { points: node.val(), story_id: POKER.story_id },
        method: 'post',
        dataType: 'json',
        cache: false,
        success: function(data) {
          // Publish results and re-draw point bars
          if (window.syncResult) {
            publishResult();
          } else {
            notifyVoted();
          }
        },
        error: function(xhr, status, err) {
          console.error(status, err.toString());
        }
      });
    }
  },
  disableVote: function() {
    $('.vote-list ul li input').addClass('disabled');
  },
  componentDidMount: function() {
    EventEmitter.subscribe("storySwitched", function(){
      $('.vote-list ul li input').removeClass('btn-info');
    });
    EventEmitter.subscribe("noStoriesLeft", this.disableVote);
  },
  render:function() {
    var currentVote = this.props.poker.currentVote;
    var that = this;
    var pointsList = this.props.poker.pointValues.map(function(point) {
      var currentVoteClassName = currentVote == point ? ' btn-info' : '';
      return (
        <li key={point}>
          <input className={'btn btn-default btn-lg' + currentVoteClassName } type="button" onClick={that.onItemClick} value={point} />
        </li>
      )
    });

    return (
      <div className="panel panel-default">
        <div className="panel-heading">Vote</div>
        <div className="vote-list panel-body row">
          <div className="col-md-12">
            <ul className="list-inline">
              {pointsList}
            </ul>
          </div>
        </div>
      </div>
    );
  }
});

var StoryListBox = React.createClass({
  loadStoryListFromServer: function(callback) {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: data});
        callback();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {data: []};
  },
  updateStoryList: function() {
    this.loadStoryListFromServer(function(){
      setupChannelSubscription();
    });
  },
  componentDidMount: function() {
    this.updateStoryList();
    EventEmitter.subscribe("storySwitched", this.updateStoryList);
  },
  componentDidUpdate: function() {
    $currentStory = $('.storyList ul li.story').not(".story-leave").first();
    if($currentStory.length) {
      POKER.story_id = $currentStory.data('id');
    } else {
      POKER.story_id = "";
      EventEmitter.dispatch("noStoriesLeft");
      drawBoard();
    }
  },
  render: function() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">Stories</div>
        <div id="storyListArea" className="panel-body row">
          <div className="storyListBox">
            <StoryList data={this.state.data} />
          </div>
        </div>
      </div>
    );
  }
});

var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;
var StoryList = React.createClass({
  render: function() {
    var storyNodes = this.props.data.map(function(story) {
      return (
        <Story key={story.id} id={story.id} link={story.link} desc={story.desc} />
      );
    });
    return (
      <div className="storyList col-md-12">
        <ul>
          <ReactCSSTransitionGroup transitionName="story" transitionEnterTimeout={500} transitionLeaveTimeout={300}>
            {storyNodes}
          </ReactCSSTransitionGroup>
        </ul>
      </div>
    );
  }
});

var Story = React.createClass({
  // rawMarkup: function() {
  //   var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
  //   return { __html: rawMarkup };
  // },

  render: function() {
    return (
      <li className="story" id={'story-' + this.props.id} data-id={this.props.id}>
        <a href={this.props.link} className="storyLink" rel="noreferrer" target="_blank">
          {this.props.link}
        </a>
        <p className="story-desc">
          {this.props.desc}
        </p>
      </li>
    );
  }
});

var PeopleListBox = React.createClass({
  loadPeopleListFromServer: function(callback) {
    $.ajax({
      url: this.props.url + '?sync=' + window.syncResult,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: data});
        if (callback) {
          callback();
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {data: []};
  },
  beforeShown: function() {
    this.loadPeopleListFromServer(function() {
      EventEmitter.dispatch("resultShown");
    })
  },
  componentDidMount: function() {
    this.loadPeopleListFromServer();
    EventEmitter.subscribe("storySwitched", this.loadPeopleListFromServer);
    EventEmitter.subscribe("beforeResultShown", this.beforeShown);
  },
  render: function() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">People</div>
        <div id="peopleListArea" className="panel-body row">
          <div className="peopleListBox">
            <PeopleList data={this.state.data} />
          </div>
        </div>
      </div>
    );
  }
});

var PeopleList = React.createClass({
  render: function() {
    var peopleNodes = this.props.data.map(function(person) {
      return (
        <Person key={person.id} name={person.name} id={person.id} role={person.display_role.toLowerCase()} points={person.points} voted={person.voted} />
      );
    });
    return (
      <div className="people-list col-md-12">
        <ul className="list-unstyled">
          {peopleNodes}
        </ul>
      </div>
    );
  }
});

var Person = React.createClass({
  render: function() {
    var userIconClass;
    if (this.props.role === 'watcher') {
      userIconClass = 'fa fa-user fa-user-secret';
    } else {
      userIconClass = 'fa fa-user';
    }

    var that = this;
    var pointLabel = (function() {
      if (window.syncResult) {
        return(
          <span className="points label label-success pull-right">
            {that.props.points}
          </span>
        );
      }
    })();

    var votedClass = '';
    if (this.props.voted) {
      votedClass = 'voted';
    }

    return (
      <li className={'person ' + votedClass} id={'u-' + this.props.id} data-point={this.props.points}>
        <i className={this.props.role + ' ' + userIconClass} aria-hidden="true"></i>
        <a href="javascript:;" className="person">
          {this.props.name}
          {pointLabel}
        </a>
      </li>
    );
  }
});

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

var ResultPanel = React.createClass({
  readFromElement: function() {
    var pointHash = {};
    $('.people-list ul li').each(function(i, ele) {
      var point = $(ele).attr('data-point')
      if (point) {
        var pointCount = pointHash[point] || 0;
        pointHash[point] = (pointCount += 1);
      }
    });

    var maxPointCount = 0;
    $.each(pointHash, function(k, v){
      if (v > maxPointCount) {
        maxPointCount = v;
      }
    });

    keys = Object.keys(pointHash),
    len = keys.length;

    keys.sort();

    var pointArray = [];
    for (i = len; i >= 0; i--) {
      point = keys[i];
      count = pointHash[point];
      barWidth = count/maxPointCount * 100;
      pointArray.push({point: point, count: count, barWidth: barWidth})
    }
    this.setState({data: pointArray});
  },
  getInitialState: function() {
    return {data: []};
  },
  componentDidMount: function() {
    EventEmitter.subscribe("resultShown", this.readFromElement)
    EventEmitter.subscribe("storySwitched", this.readFromElement)
  },
  render: function() {
    var pointBars = this.state.data.map(function(pointBar) {
      return (
        <PointBar key={pointBar.point+ '-' +pointBar.count} point={pointBar.point} count={pointBar.count} barWidth={pointBar.barWidth} />
      );
    });

    var resultChart = (function() {
      if (this.syncResult) {
        return (
          <ul className="list-unstyled">
            {pointBars}
          </ul>
        );
      } else {
        return (<div></div>);
      }
    })();

    return (
      <div className="container-fluid" style={{clear: 'both', width: '100%'}}>
        <div className="row-container container-fluid">
          {resultChart}
        </div>
      </div>
    );
  }
});

var PointBar = React.createClass({
  selectPoint: function() {
    if (POKER.role === 'Owner') {
      $.ajax({
        url: '/rooms/' + POKER.roomId + '/set_story_point.json',
        data: { point: this.props.point, story_id: POKER.story_id },
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
  render: function() {
    return (
      <li className="row" data-point={this.props.point}>
        <div className="row-container">
          <div className="col-md-2 point">{this.props.point}</div>
          <div className="col-md-9 bar">
            <div onClick={this.selectPoint} style={{width: this.props.barWidth + '%', background: 'gray', color: '#fff', 'textAlign': 'center'}}>
              {this.props.count}
            </div>
          </div>
        </div>
      </li>
    );
  }
});

var Room = React.createClass({
  rawMarkup: function() {
    var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
    return { __html: rawMarkup };
  },
  getInitialState: function() {
    return { storyListUrl: this.props.poker.storyListUrl, peopleListUrl: this.props.poker.peopleListUrl };
  },
  render: function() {
    return (
      <div>
        <div className="col-md-12 name">
          <StatusBar />
        </div>
        <div id="operationArea" className="col-md-8">
          <VoteBox poker={POKER}/>
          <StoryListBox url={this.props.poker.storyListUrl} />
        </div>

        <div className="col-md-4">
          <PeopleListBox url={this.props.poker.peopleListUrl} />
          <ActionBox />
        </div>
      </div>
    );
  }
});

var Board = React.createClass({
  rawMarkup: function() {
    var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
    return { __html: rawMarkup };
  },
  loadStoryListFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return { data: [] };
  },
  componentDidMount: function() {
    this.loadStoryListFromServer();
    $('#board .modal').modal({keyboard: false, backdrop: 'static'});
  },
  render: function() {
    var dataNodes = this.state.data.map(function(story) {
      return (
        <tr key={story.id}>
          <td>{story.link}</td>
          <td>{story.point}</td>
        </tr>
      );
    });

    return (
      <div className="modal fade" tabIndex="-1" role="dialog">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 className="modal-title">Vote Result</h4>
            </div>
            <div className="modal-body">
              <table className="table table-bordered">
                <thead>
                  <tr>
                    <th>Story</th><th>Point</th>
                  </tr>
                </thead>
                <tbody>
                  {dataNodes}
                </tbody>
              </table>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-default" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

function setupChannelSubscription() {
  // Subscribe to the public channel
  window.channelName = ['/rooms', POKER.roomId, POKER.story_id].join('/')
  var public_subscription = client.subscribe(channelName, function(data) {
    console.log(data);

    if (data.type === 'action') {
      if (data.data === 'open') {
        window.syncResult = true;
        showResultSection();
      } else if (data.data === 'refresh-stories') {
        window.syncResult = false;
        EventEmitter.dispatch("storySwitched");
      }
    } else if(data.type === 'notify') {
      var userName = data.data;
      $('.people-list li.person').each(function(i, personEle){
        var $personElement = $(personEle);
        if ($personElement.find('span').text() === userName) {
          if ($personElement.hasClass('voted')) {
            $personElement.removeClass("voted");
          }

          setTimeout(function(){
            $personElement.addClass("voted", 100);
          }, 200);
        }
      });
    } else {
      $('#u-' + data.person_id + ' .points').text(data.points);
      $('#u-' + data.person_id).attr('data-point', data.points);
    }
  });
}

function showResultSection() {
  $('#show-result').show();
  EventEmitter.dispatch("beforeResultShown");
}

function drawBoard() {
  $.ajax({
    url: '/rooms/' + POKER.roomId + '/set_room_status.json',
    data: { status: 'draw' },
    method: 'post',
    dataType: 'json',
    cache: false,
    success: function(data) {
      // pass
    },
    error: function(xhr, status, err) {
      // pass
    }
  });

  var drawBoardUrl = '/rooms/' + POKER.roomId + '/draw_board.json';
  ReactDOM.render(
    <Board url={drawBoardUrl} />,
    document.getElementById('board')
  );
}
