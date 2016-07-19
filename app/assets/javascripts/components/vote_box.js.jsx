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