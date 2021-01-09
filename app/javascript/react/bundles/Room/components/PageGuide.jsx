import React from 'react'
import Joyride from 'react-joyride'
import PropTypes from 'prop-types'

export default class PageGuide extends React.Component {

  static propTypes = {
    callback: PropTypes.func,
    isRunning: PropTypes.bool,
    steps: PropTypes.array,
    joyrideType: PropTypes.string
  }

  reset = () => {
    this.joyride.reset()
  }

  next = () => {
    this.joyride.next()
  }

  render() {
    return (
      <Joyride
        ref={c => (this.joyride = c)}
        callback={this.props.callback}
        debug={false}
        disableOverlay={true}
        locale={{
          back: (<span>Back</span>),
          close: (<span>Close</span>),
          last: (<span>Last</span>),
          next: (<span>Next</span>),
          skip: (<span>Skip</span>),
        }}
        run={this.props.isRunning}
        showOverlay={true}
        showSkipButton={true}
        showStepsProgress={true}
        steps={this.props.steps}
        type={this.props.joyrideType}
        autoStart={true}
      />
    )
  }
}