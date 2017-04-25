import PropTypes from 'prop-types';
import React from 'react';

export default class VoteBox extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      currentVote: this.props.currentVote
    }
  }

  onItemClick = (e) => {
    const node = $(e.target);
    const currentStoryId = $('.storyList ul li:first').data('id')
    if (currentStoryId) {
      this.setState({currentVote: e.target.dataset.point})
      App.rooms.perform('vote', {
        roomId: this.props.roomId,
        data: { points: node.data("point"), story_id: currentStoryId },
      });
    }
  }

  // componentDidMount = () => {
  //   EventEmitter.subscribe("refreshStories", () => {
  //     $('.vote-list ul li input').removeClass('btn-info');
  //   });
  // }

  render = () => {
    const pointsList = this.props.pointValues.map(point => {
      const currentVoteClassName = this.state.currentVote == point ? 'btn-info' : '';
      const displayPoint = pointEmojis[point] || point;
      const buttonStatusClassName = (this.props.roomState == 'draw') && "disabled"

      return (
        <li key={point}>
          <input className={`btn btn-default btn-lg ${currentVoteClassName} ${buttonStatusClassName}` } type="button" onClick={this.onItemClick} data-point={point} value={displayPoint} />
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