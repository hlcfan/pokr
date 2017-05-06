import PropTypes from 'prop-types';
import React from 'react';

export default class PointBar extends React.Component {
  selectPoint = () => {
    if (this.props.role === 'Moderator') {
      App.rooms.perform('set_story_point', {
        roomId: this.props.roomId,
        data: { point: this.props.point, story_id: this.props.story_id }
      });
    }
  }

  render() {
    var pointIndicator = pointEmojis[this.props.point] || this.props.point;

    return (
      <li className="row" data-point={this.props.point}>
        <div className="row-container">
          <div className="col-md-2 point">{pointIndicator}</div>
          <div className="col-md-9 bar">
            <div onClick={this.selectPoint} style={{width: this.props.barWidth + '%', background: this.props.color, color: '#fff', 'textAlign': 'center'}}>
              {this.props.count}
            </div>
          </div>
        </div>
      </li>
    )
  }
}