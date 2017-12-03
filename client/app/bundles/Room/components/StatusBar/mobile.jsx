import PropTypes from 'prop-types'
import React from 'react'
import {HOC} from './hoc'
import {defaultTourColor} from 'libs/barColors'
import QRCode from 'qrcode.react'
import css from './index.scss'

class StatusBarMobile extends React.Component {
  componentDidMount() {
    this.props.addSteps({
      title: 'Menu bar',
      text: "Share the QR code to others. You can change room status or edit from here if you're a moderator, or change your role",
      selector: `.${css["status-bar__operations"]}`,
      position: 'right',
      style: defaultTourColor
    })
  }

  render() {
    const roomStatusButton = (() => {
      if ('Moderator' === this.props.role) {
        return (
          <a onClick={this.closeRoom}>🏁 Close</a>
        )
      }
    })()

    const editButton = (() => {
      if('Moderator' === this.props.role) {
        return(
          <a href={`/rooms/${this.props.roomId}/edit`}>✏️ Edit</a>
        )
      }
    })();

    const operationButtons = (() => {
      if (this.props.roomState !== "draw") {
        return(
          <ul className="dropdown-menu" aria-labelledby="dropdownMenu1">
            <li>{editButton}</li>
            <li>{roomStatusButton}</li>
            <li><a href="javascript:;" onClick={this.props.playTourGuide}>
              <i className="fa fa-question-circle" aria-hidden="true"></i> Take a tour
            </a></li>
            <li><a href="javascript:;">🔳 QR code</a></li>
            <div className={css['status-bar__qr']}><QRCode value={location.href} /></div>
          </ul>
        )
      }
    })();

    const userRoleClassName = role => {
      // Dont allow moderator to switch role at the moment
      if (role === this.props.role || "Moderator" === this.props.role) {
        return "disabled";
      } else {
        return "";
      }
    };

    const currentRoleEmoji = (() => {
      if ("Moderator" === this.props.role) {
        return "👑";
      } else if ("Participant" === this.props.role) {
        return "👷";
      } else {
        return "👲";
      }
    })();

    return (
      <div className={`${css["room__status_bar"]} row`}>
        <div className="col-md-12 col-xs-12">
          <h3 className={`pull-left ${css.room__title}`}>{this.props.roomName}</h3>
        </div>
        <div className={`col-md-12 col-xs-12 ${css['status-bar__operations']}`}>
          <div className="row">
            <div className="dropdown col-md-6 col-xs-6">
              <button className="btn btn-default dropdown-toggle" type="button" id="dropdown-operation" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                <i className="fa fa-wrench"></i> &nbsp; Options &nbsp;
                <span className="caret"></span>
              </button>
              {operationButtons}
            </div>
            <div className="dropdown col-md-6 col-xs-6">
              <button className="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                {currentRoleEmoji} &nbsp;{this.props.role} &nbsp;
                <span className="caret"></span>
              </button>
              <ul className="dropdown-menu" aria-labelledby="dropdownMenu1">
                <li className={userRoleClassName("Watcher")}><a onClick={this.beWatcher} href="javascript:;">Be watcher 👲</a></li>
                <li className={userRoleClassName("Participant")}><a onClick={this.beParticipant} href="javascript:;">Be participant 👷</a></li>            </ul>
            </div>
          </div>
          <div id="tooltip-area"></div>
        </div>
        <div className="col-md-4 col-xs-4">
        </div>
      </div>
    )
  }
}
const StatusBar = HOC(StatusBarMobile)
export default StatusBar