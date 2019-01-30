import PropTypes from 'prop-types'
import React from 'react'
import update from 'immutability-helper'
import EventEmitter from 'libs/eventEmitter'

export default class CountDownTimer extends React.Component {

  static propTypes = {
    countDown: PropTypes.number
  }

  constructor(props) {
    super(props)

    this.state = {
      storyId: props.storyId,
      countDown: props.countDown
    }
  }

  componentDidMount() {
    EventEmitter.subscribe("resetActionBox", this.resetTimer)
    if (this.props.countDown > 0) {
      this.intervalId = setInterval(this.timer, 1000)
    }
  }

  resetTimer = () => {
    this.setState({
      storyId: this.props.storyId,
      countDown: this.props.countDown
    })

    if (this.props.countDown > 0) {
      if (this.intervalId) {
        clearInterval(this.intervalId)
      }
      this.intervalId = setInterval(this.timer, 1000)
    }
  }

  timer = () => {
    // debugger
    let newState = update(this.state, {
      countDown: { $set: this.state.countDown - 1 }
    })

    this.setState(newState)

    if(this.state.countDown < 1) {
      clearInterval(this.intervalId);
    }
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      storyId: nextProps.storyId,
      countDown: this.state.countDown
    })
  }

  componentWillUnmount() {
    clearInterval(this.intervalId);
  }

  render() {
    if (this.state.countDown < 1) {
      // console.log("====Warning")
      return(
        <span className="timer pull-right">
          <i className="fa warning">⚠️</i>
          Time out
        </span>
      )
    } else {
      // console.log("====Counting")
      return(
        <span className="timer pull-right">
          <i className="fa sandglass">⌛</i>
          &nbsp;
          <i className="counter">{this.state.countDown}</i>
        </span>
      )
    }
  }
}

// if (this.state.roomState !== "draw" && this.props.countDown > 0) {
//   clearInterval(this.intervalId)
//   this.intervalId = setInterval(this.timer, 1000)
// }