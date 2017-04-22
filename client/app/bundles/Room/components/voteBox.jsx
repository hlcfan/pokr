import PropTypes from 'prop-types';
import React from 'react';

export default class VoteBox extends React.Component {
  onItemClick(e) {
    const node = $(e.target);
    if (POKER.story_id) {
      // Remove all selected points
      $('.vote-list ul li input').removeClass('btn-info');
      node.toggleClass('btn-info');
      App.rooms.perform('vote', {
        roomId: POKER.roomId,
        data: { points: node.data("point"), story_id: POKER.story_id },
      });
    }
  }

  disableVote() {
    $('.vote-list ul li input').addClass('disabled');
  }

  componentDidMount() {
    EventEmitter.subscribe("refreshStories", () => {
      $('.vote-list ul li input').removeClass('btn-info');
    });
    EventEmitter.subscribe("roomClosed", this.disableVote);
  }

  render() {
    const currentVote = this.props.poker.currentVote;
    const that = this;
    const pointsList = this.props.poker.pointValues.map(point => {
      const currentVoteClassName = currentVote == point ? ' btn-info' : '';
      const displayPoint = pointEmojis[point] || point;

      return (
        <li key={point}>
          <input className={`btn btn-default btn-lg${currentVoteClassName}` } type="button" onClick={that.onItemClick} data-point={point} value={displayPoint} />
        </li>
      )
    });

    return (
      <div className="panel panel-default">
        <div className="panel-heading">Deck</div>
        <div className="vote-list panel-body row">
          <div className="col-md-12">
            <ul className="list-inline">
              {pointsList}
            </ul>
          </div>
        </div>
      </div>
    )
  }
}