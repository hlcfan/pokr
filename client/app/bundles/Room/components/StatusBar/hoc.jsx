import PropTypes from 'prop-types'
import React from 'react'
import {defaultTourColor} from 'libs/barColors'
import css from './index.scss'

const MODERATOR_ROLE = 0
const PARTICIPANT_ROLE = 1
const WATCHER_ROLE = 2

export const HOC = (WrappedComponent) => class extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      role: this.props.role
    }
  }

  closeRoom = () => {
    if (confirm("WARNING: Do you want to close this room? This cannot be undone.")) {
      App.rooms.perform('action', {
        roomId: this.props.roomId,
        data: "close-room",
        type: 'action'
      });
    }
  }

  beWatcher = () => {
    if ("Watcher" === this.props.role || 'Moderator' === this.props.role)
      return

    $.ajax({
      url: `/rooms/${this.props.roomId}/switch_role`,
      cache: false,
      type: 'POST',
      data: { role: WATCHER_ROLE },
      success: data => {
        this.setState({ role: "Watcher" })
      },
      error: (xhr, status, err) => {
        console.error("Switch role failed!")
      }
    })
  }

  beParticipant = () => {
    if ("Participant" === this.props.role || 'Moderator' === this.props.role)
      return

    $.ajax({
      url: `/rooms/${this.props.roomId}/switch_role`,
      cache: false,
      type: 'POST',
      data: { role: PARTICIPANT_ROLE },
      success: data => {
        this.setState({ role: "Participant" })
      },
      error: (xhr, status, err) => {
        console.error("Switch role failed!")
      }
    })
  }

  playTourGuide = () => {
    this.props.playTourGuide()
  }

  render = () => {
    return(
      <WrappedComponent {...this.props}
        closeRoom={this.closeRoom}
        beWatcher={this.beWatcher}
        beParticipant={this.beParticipant}
        playTourGuide={this.playTourGuide}
      />
    )
  }
}