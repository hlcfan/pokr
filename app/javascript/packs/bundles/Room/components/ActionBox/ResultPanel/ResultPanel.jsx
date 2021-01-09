import PropTypes from 'prop-types'
import React from 'react'
import PointBar from '../PointBar/PointBar'
import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'

export default class ResultPanel extends React.Component {

  constructor(props) {
    super(props)
    this.state = { data: [] }
  }

  componentDidMount = () => {
    EventEmitter.subscribe("showResultPanel", (data) => {
      this.setState({ data: data })
    })
  }

  render() {
    // TODO
    // Gotta find out why it could be null sometimes
    if (!this.state.data) {
      return null
    }

    let pointHash = {}
    $.each(this.state.data, (index, voteObject) => {
      const point = voteObject.points
      if (point) {
        let pointCount = pointHash[point] || 0
        pointHash[point] = (pointCount += 1)
      }
    })

    let maxPointCount = 0
    $.each(pointHash, (point, count) => {
      if (count > maxPointCount) {
        maxPointCount = count
      }
    })

    let keys = Object.keys(pointHash)
    let len = keys.length

    keys.sort((a, b) => parseInt(a) - parseInt(b))

    let pointArray = []
    let i, j, point, count, barWidth, color
    for (i = (len-1), j=0; i >= 0; i--, j++) {
      point = keys[i]
      count = pointHash[point]
      barWidth = count/maxPointCount * 100
      color = BarColors.color(point) || BarColors.randomColor()
      pointArray.push({ point, count, barWidth, color })
    }

    const pointBars = pointArray.map(
      pointBar =>
        <PointBar key={`${pointBar.point}-${pointBar.count}`}
          point={pointBar.point} count={pointBar.count}
          barWidth={pointBar.barWidth}
          color={pointBar.color}
          roomId={this.props.roomId}
          role={this.props.role}
          storyId={this.props.storyId}
          />)

    const resultChart = (function() {
      if (window.syncResult) {
        return (
          <ul className="list-unstyled">
            {pointBars}
          </ul>
        )
      } else {
        return (<div></div>)
      }
    })()

    return (
      <div className="container-fluid" style={{clear: 'both', width: '100%'}}>
        <div className="row-container container-fluid">
          {resultChart}
        </div>
      </div>
    )
  }
}
