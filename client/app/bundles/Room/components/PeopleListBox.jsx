import PropTypes from 'prop-types'
import React from 'react'
import PeopleList from '../components/PeopleList'
import Invitation from '../components/Invitation/index'
import EventEmitter from 'libs/eventEmitter'
import {defaultTourColor} from 'libs/barColors'
import css from './Invitation/index.scss'

export default class PeopleListBox extends React.Component {

  state = { data: [], editable: false }

  loadPeopleListFromServer = () => {
    $.ajax({
      url: `/rooms/${this.props.roomId}/user_list.json?sync=${window.syncResult}`,
      dataType: 'json',
      cache: false,
      success: data => {
        this.setState(prevState => {
          return { data }
        })
        EventEmitter.dispatch("showResultPanel", data)
      },
      error: (xhr, status, err) => {
        console.error("Fetching people list", status, err.toString());
      }
    })
  }

  componentDidMount() {
    this.loadPeopleListFromServer()
    EventEmitter.subscribe("refreshUsers", this.loadPeopleListFromServer)

    this.props.addSteps({
      title: 'People',
      text: "Current attendees are listed here. The blue bars indicate voting status. When the moderator flips the cards, the point will display next to each person's name.",
      selector: '#people',
      position: 'top-right',
      style: defaultTourColor
    })
  }

  invite = () => {
    $('#invitation .modal').modal({keyboard: false, backdrop: 'static'})
  }

  edit = () => {
    this.setState(prevState => {
      return { editable: true }
    })
  }

  roomClosed = () => {
    return "draw" === this.state.roomState
  }

  render() {
    return (
      <div className="panel panel-default" id="people">
        <div className="panel-heading">
          People
          <a className={`pull-right ${css.invitation__link}`} href="javascript:;" onClick={this.invite}>
            <i className="fa fa-plus-circle"></i> Invite
          </a>
          {
            this.props.role === 'Moderator' &&
              <a className={`pull-right ${css.invitation__link}`} href="javascript:;" onClick={this.edit}>
                <i className="fa fa-edit"></i> Edit
              </a>
          }
        </div>
        <div id="peopleListArea" className="panel-body row">
          <div className="peopleListBox">
            <PeopleList
              data={this.state.data}
              editable={this.state.editable}
              role={this.props.role}
              roomId={this.props.roomId}
              currentUserId={this.props.currentUserId}
            />
          </div>
        </div>
        {
          !this.roomClosed() &&
            <Invitation roomId={this.props.roomId} />
        }
      </div>
    )
  }
}
