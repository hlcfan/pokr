import PropTypes from 'prop-types'
import React from 'react'
import BarColors from 'libs/barColors'

export default class Person extends React.Component {
  render() {
    const that = this;
    const pointLabel = ((() => {
      if (window.syncResult) {
        return(
          <span className="points pull-right">
            {BarColors.emoji(that.props.points) || that.props.points}
          </span>
        );
      }
    }))();

    let votedClass = '';
    if (this.props.voted) {
      votedClass = 'voted';
    }

    return (
      <li className={`${this.props.role} person ${votedClass}`} id={`u-${this.props.id}`} data-point={this.props.points}>
        <i className="person--avatar">
          <img src={this.props.avatar} />
        </i>
        <a href="javascript:;" className="person">
          {this.props.name}
          {pointLabel}
        </a>
      </li>
    )
  }
}