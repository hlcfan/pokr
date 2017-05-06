import PropTypes from 'prop-types';
import React from 'react';
import PointBar from '../components/PointBar';
import EventEmitter from 'libs/eventEmitter';

export default class ResultPanel extends React.Component {
  state = {
    data: []
  }

  readFromElement = () => {
    const pointHash = {};
    const $peopleList = $('.people-list ul li');
    if ($peopleList.length <= 0) {
      return false;
    }
    $peopleList.each((i, ele) => {
      const point = $(ele).attr('data-point');
      if (point) {
        let pointCount = pointHash[point] || 0;
        pointHash[point] = (pointCount += 1);
      }
    });

    let maxPointCount = 0;
    $.each(pointHash, (k, v) => {
      if (v > maxPointCount) {
        maxPointCount = v;
      }
    });

    let keys = Object.keys(pointHash)
    let len = keys.length

    keys.sort((a, b) => parseInt(a) - parseInt(b));

    let pointArray = [];
    let i, j, point, count, barWidth;
    for (i = (len-1), j=0; i >= 0; i--, j++) {
      point = keys[i];
      count = pointHash[point];
      barWidth = count/maxPointCount * 100;
      pointArray.push({point, count, barWidth, color: barColors[point]})
    }
    this.setState({data: pointArray});
  }

  componentDidMount = () => {
    EventEmitter.subscribe("showResultPanel", this.readFromElement);
  }

  render() {
    const pointBars = this.state.data.map(
      pointBar =>
        <PointBar key={`${pointBar.point}-${pointBar.count}`}
          point={pointBar.point} count={pointBar.count}
          barWidth={pointBar.barWidth}
          color={pointBar.color}
          roomId={this.props.roomId}
          role={this.props.role}
          storyId={this.props.storyId}
          />);

    const resultChart = (function() {
      if (window.syncResult) {
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
    )
  }
}