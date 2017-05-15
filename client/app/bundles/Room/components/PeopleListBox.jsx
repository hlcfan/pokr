import PropTypes from 'prop-types'
import React from 'react'
import PeopleList from '../components/PeopleList'
import EventEmitter from 'libs/eventEmitter'
import {defaultTourColor} from 'libs/barColors'

export default class PeopleListBox extends React.Component {

  state = { data: [] }

  loadPeopleListFromServer = (callback) => {
    $.ajax({
      url: `/rooms/${this.props.roomId}/user_list.json?sync=${window.syncResult}`,
      dataType: 'json',
      cache: false,
      success: data => {
        this.setState({ data: data })
        EventEmitter.dispatch("showResultPanel", data)
      },
      error: (xhr, status, err) => {
        console.error("Fetching people list", status, err.toString());
      }
    })
  }

  componentDidMount() {
    this.loadPeopleListFromServer();
    EventEmitter.subscribe("refreshUsers", this.loadPeopleListFromServer)

    this.props.addSteps({
      title: 'People',
      text: "Whoever joins in this room will be in this list. It indicates the voting status by showing a blue bar. When moderator flips the cards, the point will be show following one's name.",
      selector: '#people',
      position: 'top-right',
      style: defaultTourColor
    })
  }

  render() {
    return (
      <div className="panel panel-default" id="people">
        <div className="panel-heading">People</div>
        <div id="peopleListArea" className="panel-body row">
          <div className="peopleListBox">
            <PeopleList data={this.state.data} />
          </div>
        </div>
      </div>
    )
  }
}