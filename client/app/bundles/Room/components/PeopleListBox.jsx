import PropTypes from 'prop-types'
import React from 'react'
import PeopleList from '../components/PeopleList'
import EventEmitter from 'libs/eventEmitter'
import {defaultTourColor} from 'libs/barColors'

export default class PeopleListBox extends React.Component {

  state = { data: [] }

  loadPeopleListFromServer = (flip) => {
    let newData;

    $.ajax({
      url: `/rooms/${this.props.roomId}/user_list.json?sync=${window.syncResult}`,
      dataType: 'json',
      cache: false,
      success: data => {
        this.setState({ data: data })
        if (flip) {
          newData = { value: data, fromFlip: true }
        } else {
          newData = { value: data }
        }
        EventEmitter.dispatch("showResultPanel", newData)
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
      text: "Whoever joins in this room will be in this list. It also indicates the voting status by showing a blue bar next to avatar. When moderator flips the cards, the point will be showing following one's name.",
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