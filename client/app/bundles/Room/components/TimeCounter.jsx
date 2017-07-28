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

  onUnload = (event) => {
    event.preventDefault()
    this.sendRealtimeDuration()
    return event.returnValue = 'Are you sure you want to close?'
  }

  sendRealtimeDuration = () => {
    let duration = this.duration + TimeMe.getTimeOnCurrentPageInSeconds()

    $.ajax({
      url: `/rooms/${this.props.roomId}/timing`,
      data: { duration: duration },
      method: 'post',
      cache: false,
      success: function(data) {
        // pass
      },
      error: function(xhr, status, err) {
        // pass
      }
    })
  }

  componentDidMount() {
    TimeMe.initialize({
      currentPageName: this.props.roomId,
      idleTimeoutInSeconds: 120
    })

    window.addEventListener("beforeunload", this.onUnload)

    setInterval(() => {
      this.sendRealtimeDuration()
    }, 2000)
  }

  componentWillUnmount() {
    window.removeEventListener("beforeunload", this.onUnload)
  }

  render() {
    return (
      <div></div>
    )
  }
}