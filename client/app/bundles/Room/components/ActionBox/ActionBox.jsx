import PropTypes from 'prop-types'
import React from 'react'
import ResultPanel from './ResultPanel/ResultPanel'
import EventEmitter from 'libs/eventEmitter'
import update from 'immutability-helper'
import RoomActions from 'libs/roomActions'
import {defaultTourColor} from 'libs/barColors'

export default class ActionBox extends React.Component {
  constructor(props){
    super(props);

    this.state = {
      roomState: this.props.roomState,
      countDown: this.props.countDown,
    }
  }

  timer = () => {
    let newState = update(this.state, {
      countDown: { $set: this.state.countDown - 1 }
    })

    this.setState(newState)

    if(this.state.countDown < 1) {
      clearInterval(this.intervalId);
    }
  }

  showResult = (e) => {
    let newState = update(this.state, {
      roomState: { $set: "open" }
    })

    this.setState(newState)

    if (this.props.role === 'Moderator' && this.state.roomState !== 'open') {
      MessageBus.publish("action", {
        roomId: this.props.roomId,
        data: 'open',
        type: 'action'
      })
    }
  }

  skipStory = () => {
    if (this.props.role === 'Moderator') {
      MessageBus.publish("set_story_point", {
        roomId: this.props.roomId,
        data: { point: 'null', story_id: this.props.storyId }
      })
    }
  }

  clearVotes = () => {
    if (this.props.role === 'Moderator') {
      MessageBus.publish("clear_votes", {
        roomId: this.props.roomId,
        data: { story_id: this.props.storyId }
      })
    }
  }

  resetActionBox = () => {
    let newState = update(this.state, {
      roomState: { $set: "not-open" },
      countDown: { $set: this.props.countDown }
    })

    this.setState(newState)

    if (this.state.roomState !== "draw" && this.props.countDown > 0) {
      clearInterval(this.intervalId)
      this.intervalId = setInterval(this.timer, 1000)
    }
  }

  showBoard = () => {
    EventEmitter.dispatch("showBoard")
  }

  dismissTip = () => {
    Cookies.set("tipClosed", true)
  }

  componentDidMount() {
    EventEmitter.subscribe("resetActionBox", this.resetActionBox)
    if (this.props.roomState !== "draw" && this.props.countDown > 0) {
      this.intervalId = setInterval(this.timer, 1000)
    }
    if (this.props.roomState === 'open') {
      RoomActions.showResultSection()
    }

    let text
    let title
    if ("Moderator" === this.props.role) {
      title = "Actions"
      text = "Point actions will be displayed in this panel. You can choose the final estimate (click on the point bar), clear votes, or skip the current story."
    } else {
      title = "Votes"
      text = "You will see estimations here. Only the moderator can decide the final estimation."
    }

    this.props.addSteps({
      title: title,
      text: text,
      selector: '#action-box',
      position: 'top-right',
      style: defaultTourColor
    })
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      roomState: nextProps.roomState,
      countDown: this.state.countDown
    })
  }

  componentWillUnmount() {
    clearInterval(this.intervalId);
  }

  render() {
    let onClickName;
    let buttonText;
    let buttonHtml;
    let secondButtonText;
    let secondOnClickName;
    let buttonCount = 1;

    if (this.props.role === 'Moderator') {
      if (this.state.roomState === 'not-open') {
        onClickName = this.showResult;
        buttonText = "Flip";
      } else if (this.state.roomState === 'open') {
        onClickName = this.skipStory;
        buttonText = "Skip it";
        secondOnClickName = this.clearVotes;
        secondButtonText = "Clear votes"
        buttonCount = 2;
      } else if (this.state.roomState === 'draw') {
        onClickName = this.showBoard;
        buttonText = "Show results";
      }
    }
    buttonHtml = ((() => {
      if (onClickName && buttonText && buttonCount > 1) {
        return (
          <div className="row" role="group">
            <a onClick={onClickName} className="col-md-5" href="javascript:;" role="button">
              {buttonText}
            </a>
          <span className="col-md-2"></span>
            <a onClick={secondOnClickName} className="col-md-5" href="javascript:;" role="button">
              {secondButtonText}
            </a>
          </div>
        )
      } else if (onClickName && buttonText) {
        return (
          <div className="" role="group">
            <a onClick={onClickName} className="btn btn-default btn-lg btn-info btn-block" href="javascript:;" role="button">
              {buttonText}
            </a>
          </div>
        )
      }
    }))()

    const tip = ((() => {
      // if tip not closed yet, which means keep showing tip
      if (!Cookies.get('tipClosed') && this.props.role === 'Moderator') {
        let pointClicked = Cookies.get("pointClicked")

        return (
          <div className="container-fluid" style={{clear: 'both', width: '90%'}}>
            <div className="alert alert-success alert-dismissible" role="alert">
              {
                pointClicked &&
                  <button type="button" className="close" data-dismiss="alert" aria-label="Close" onClick={this.dismissTip}><span aria-hidden="true">&times;</span></button>
              }
              Tip: click on the <b>colorful bar</b> below to decide the point.
            </div>
          </div>
        )
      }
    }))()

    const icon = () => {
      if ("draw" !== this.props.roomState && this.props.countDown) {
        if (this.state.countDown < 1) {
          return(
            <span className="timer pull-right">
              <i className="fa warning">⚠️</i>
              Time out
            </span>
          )
        } else {
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

    let showOpenButton = () => {
      return this.state.roomState === "open" ? "openButton" : ""
    }

    return (
      <div className="panel panel-default" id="action-box">
        <div className="panel-heading">
          { this.props.role === "Moderator" ? "Action" : "Result" }
          {icon()}
        </div>
        <div className="panel-body row">
          <div id="actionBox">
            { this.state.roomState === 'open' && tip }
            <ResultPanel roomId={this.props.roomId} role={this.props.role} storyId={this.props.storyId} />
            {
              this.props.role === "Moderator" &&
                <div className={`${showOpenButton()} container-fluid`}>
                  {buttonHtml}
                </div>
            }
          </div>
        </div>
      </div>
    )
  }
}
