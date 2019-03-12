import PropTypes from 'prop-types'
import React from 'react'
import BarColors from 'libs/barColors'
import CursorImage from './check.cur'
import css from './index.scss'

export default class PointBar extends React.Component {
  selectPoint = () => {
    if (this.props.role === 'Moderator') {
      Cookies.set("pointClicked", true)
      App.rooms.perform('set_story_point', {
        roomId: this.props.roomId,
        data: { point: this.props.point, story_id: this.props.storyId }
      })
    }
  }

  render() {
    var pointIndicator = BarColors.emoji(this.props.point) || this.props.point;
    let cursorStyle
    if ("Moderator" === this.props.role) {
      cursorStyle = { cursor: `url(${CursorImage}), auto` }
    }

    return (
      <li className="row" data-point={this.props.point}>
        <div className="col-md-2 col-xs-2 point">{pointIndicator}</div>
        <div className="col-md-9 col-xs-9 bar" style={cursorStyle}>
          <div onClick={this.selectPoint} style={{width: this.props.barWidth + '%', background: this.props.color, color: '#fff', 'textAlign': 'center'}}>
            {this.props.count}
            {
              ("Moderator" === this.props.role) &&
              <i className={`fa fa-angle-double-right ${css["point-bar__accessory"]}`}></i>
            }
          </div>
        </div>
      </li>
    )
  }
}
