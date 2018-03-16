import PropTypes from 'prop-types'
import React from 'react'
import BarColors from 'libs/barColors'
import EventEmitter from 'libs/eventEmitter'

export default class Person extends React.Component {

  remove = () => {
    if (this.props.role === 'Moderator') {
      App.rooms.perform('remove_person', {
        roomId: this.props.roomId,
        data: { user_id: this.props.id }
      })
    }
  }

  evictUser = (userId) => {
    if (this.props.currentUserId === userId) {
      window.location.href = "/"
    }
  }

  componentDidMount() {
    EventEmitter.subscribe("evictUser", this.evictUser)
  }

  render() {
    const that = this;
    const accessoryLabel = ((() => {
      if (this.props.editable && this.props.currentUserId !== this.props.id) {
        return(
          <span className="accessory pull-right" onClick={this.remove}>
            <i className="fa fa-trash-o"></i>
          </span>
        )
      } else {
        if (window.syncResult) {
          return(
            <span className="accessory pull-right">
              {BarColors.emoji(that.props.points) || that.props.points}
            </span>
          )
        }
      }
    }))()

    let votedClass = '';
    if (this.props.voted) {
      votedClass = 'voted'
    }

    return (
      <li className={`${this.props.role} person ${votedClass}`} id={`u-${this.props.id}`} data-point={this.props.points}>
        <i className="person--avatar">
          <img src={this.props.avatar} />
        </i>
        <a href="javascript:;" className="person">
          {this.props.name}
          {accessoryLabel}
        </a>
      </li>
    )
  }
}