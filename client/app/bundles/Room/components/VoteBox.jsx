import PropTypes from 'prop-types'
import React from 'react'
import BarColors from 'libs/barColors'
import EventEmitter from 'libs/eventEmitter'

export default class VoteBox extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      currentVote: props.currentVote
    }
  }

  onItemClick = (e) => {
    this.setState({currentVote: e.target.dataset.point})
    App.rooms.perform('vote', {
      roomId: this.props.roomId,
      data: { points: e.target.dataset.point, story_id: this.props.storyId },
    })
  }

  componentDidMount() {
    EventEmitter.subscribe("refreshStories", () => {
      this.setState({ currentVote: null })
    })
  }

  render() {
    const pointsList = this.props.pointValues.map(point => {
      const currentVoteClassName = this.state.currentVote === point ? 'btn-info' : ''
      const displayPoint = BarColors.emoji(point) || point
      const buttonStatusClassName = (this.props.roomState === 'draw') && "disabled"

      return (
        <li key={point}>
          <input className={`btn btn-default btn-lg ${currentVoteClassName} ${buttonStatusClassName}` } type="button" onClick={this.onItemClick} data-point={point} value={displayPoint} />
        </li>
      )
    })

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