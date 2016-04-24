/**
 * This file provided by Facebook is for non-commercial testing and evaluation
 * purposes only. Facebook reserves all rights not expressly granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

var Room = React.createClass({
  rawMarkup: function() {
    var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
    return { __html: rawMarkup };
  },

  render: function() {
    return (
      <div className="room">
        <h2 className="roomId">
          {this.props.id}
        </h2>
        <h2 className="roomName">
          {this.props.name}
        </h2>
        <span dangerouslySetInnerHTML={this.rawMarkup()} />
      </div>
    );
  }
});

var StoryListBox = React.createClass({
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
    return {data: []};
  },
  componentDidMount: function() {
    this.loadStoryListFromServer();
    setInterval(this.loadStoryListFromServer, this.props.pollInterval);
  },
  render: function() {
    return (
      <div className="storyListBox">
        <StoryList data={this.state.data} />
      </div>
    );
  }
});

var StoryList = React.createClass({
  render: function() {
    var storyNodes = this.props.data.map(function(story) {
      return (
        <Story key={story.link} link={story.link} desc={story.desc} />
      );
    });
    return (
      <div className="storyList col-md-12">
        <ul>
          {storyNodes}
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
      <li className="story">
        <a href={this.props.link} className="storyLink">
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
  loadPeopleListFromServer: function() {
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
    return {data: []};
  },
  componentDidMount: function() {
    this.loadPeopleListFromServer();
    setInterval(this.loadPeopleListFromServer, this.props.pollInterval);
  },
  render: function() {
    return (
      <div className="peopleListBox">
        <PeopleList data={this.state.data} />
      </div>
    );
  }
});

var PeopleList = React.createClass({
  render: function() {
    var peopleNodes = this.props.data.map(function(person) {
      return (
        <Person key={person.id} name={person.name} id={person.id} role={person.display_role.toLowerCase()} points={person.points} />
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

    return (
      <li className="person" id={'u-' + this.props.id} data-point={this.props.points}>
        <i className={this.props.role + ' ' + userIconClass} aria-hidden="true"></i>
        <a href="javascript:;" className="person">
          {this.props.name}
          <span className="points label label-success pull-right">{this.props.points}</span>
        </a>
      </li>
    );
  }
});

var ResultList = React.createClass({
  render: function() {
    // var peopleNodes = this.props.data.map(function(person) {
    //   return (
    //     <Person key={person.id} name={person.name} id={person.id} role={person.display_role.toLowerCase()} points={person.points} />
    //   );
    // });
    return (
      <div className="col-md-12">
        
      </div>
    );
  }
});

$(document).on("page:change", function() {
  var storyListUrl = "/rooms/"+POKER.room_id+"/story_list.json";
  var peopleListUrl = "/rooms/"+POKER.room_id+"/user_list.json";
  ReactDOM.render(
    // Interval was 2000
    <StoryListBox url={storyListUrl} pollInterval={2000000} />,
    document.getElementById('storyListArea')
  );

  ReactDOM.render(
    // Interval was 2000
    <PeopleListBox url={peopleListUrl} pollInterval={10000} />,
    document.getElementById('peopleListArea')
  );

  POKER.story_id = 1;
  Cookies.set('story_id', POKER.story_id);

  function drawResult() {
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
        maxPointCount = 1;
      }
    });

    keys = Object.keys(pointHash),
    len = keys.length;

    keys.sort();
    keys.reverse();

    var colorArray = ['']
    $('#show-result .row-container').html('');
    for (i = 0; i < len; i++) {
      point = keys[i];
      count = pointHash[point];

      barWidth = count/maxPointCount * 100;

      $('#show-result .row-container').append("<div class='row'><div class='col-md-1'>"+point+"</div><div class='col-md-10'><div style='width:"+barWidth+"%; background:gray; color: transparent;'>aaaa</div></div></div>");
    }

    // alert(maxPointCount)
  }

  window.client = new Faye.Client('http://localhost:9292/faye');
 
  // Subscribe to the public channel
  var channelName = ['/rooms', POKER.room_id, POKER.story_id].join('/')
  var public_subscription = client.subscribe(channelName, function(data) {
    console.log(data);
    if (data.type === 'action') {
      drawResult();
    } else {
      $('#u-' + data.person_id + ' .points').text(data.points);
      $('#u-' + data.person_id).attr('data-point', data.points);
    }
  });

  $('#open-result a').click(function(){
    client.publish(channelName, {
      data: 'open',
      type: 'action'
    });
  })

});
