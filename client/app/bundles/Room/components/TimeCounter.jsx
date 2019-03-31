import PropTypes from 'prop-types'
import React from 'react'
import TimeMe from 'timeme.js'

export default class TimeCounter extends React.Component {

  static propTypes = {
    roomId: PropTypes.string,
    initialDuration: PropTypes.number
  }

  constructor(props) {
    super(props)
    this.duration = props.initialDuration
  }

  sendRealtimeDuration = () => {
    let duration = this.duration + TimeMe.getTimeOnCurrentPageInSeconds()
    Messenger.publish('timing', {
      roomId: this.props.roomId,
      data: { duration: duration },
    })
  }

  componentDidMount() {
    TimeMe.initialize({
      currentPageName: this.props.roomId,
      idleTimeoutInSeconds: 600
    })

    setInterval(() => {
      this.sendRealtimeDuration()
    }, 30000)
  }

  render() {
    return (
      <div></div>
    )
  }
}
