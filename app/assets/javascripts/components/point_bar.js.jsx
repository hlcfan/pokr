var PointBar = React.createClass({
  selectPoint: function() {
    if (POKER.role === 'Moderator') {
      App.rooms.perform('set_story_point', {
        roomId: POKER.roomId,
        data: { point: this.props.point, story_id: POKER.story_id }
      });
      // $.ajax({
      //   url: '/rooms/' + POKER.roomId + '/set_story_point.json',
      //   data: { point: this.props.point, story_id: POKER.story_id },
      //   method: 'post',
      //   dataType: 'json',
      //   cache: false,
      //   success: function(data) {
      //     refreshStories();
      //     refreshPeople();
      //     resetActionBox();
      //   },
      //   error: function(xhr, status, err) {
      //     console.error(status, err.toString());
      //   }
      // });
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