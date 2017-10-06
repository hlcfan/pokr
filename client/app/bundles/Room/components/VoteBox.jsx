import PropTypes from 'prop-types'
import React from 'react'
import BarColors, {defaultTourColor} from 'libs/barColors'
import EventEmitter from 'libs/eventEmitter'

export default class VoteBox extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      currentVote: props.currentVote
    }
  }

  onItemClick = (e) => {
    if ("draw" !== this.props.roomState) {
      let targetPoint = e.target.getAttribute("data-point")
      this.setState({currentVote: targetPoint})
      App.rooms.perform('vote', {
        roomId: this.props.roomId,
        data: { points: targetPoint, story_id: this.props.storyId },
      })
    }
  }

  componentDidMount() {
    EventEmitter.subscribe("refreshStories", () => {
      this.setState({ currentVote: null })
    })

    this.props.addSteps({
      title: 'Deck',
      text: 'All the points are listed in this panel. Click on a point to select your estimate. ⁉️ means "unsure" and ☕ means "I need a break".',
      selector: '#deck',
      position: 'top-right',
      style: defaultTourColor
    })
  }

  render() {
    const pointsList = this.props.pointValues.map(point => {
      const currentVoteClassName = this.state.currentVote === point ? 'btn-info' : ''
      const displayPoint = BarColors.emoji(point) || point
      const buttonStatusClassName = ('draw' === this.props.roomState) && "disabled"

      return (
        <li key={point} className="col-sm-2">
          <input className={`btn btn-default btn-lg ${currentVoteClassName} ${buttonStatusClassName}` } type="button" onClick={this.onItemClick} data-point={point} value={displayPoint} />
        </li>
      )
    })

    return (
      <div className="panel panel-default" id="deck">
        <div className="panel-heading">Deck</div>
        <div className="vote-list panel-body">
          <ul className="list-inline">
            {pointsList}
          </ul>
        </div>
      </div>
    )
  }
}
