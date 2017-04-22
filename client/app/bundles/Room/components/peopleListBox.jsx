import PropTypes from 'prop-types';
import React from 'react';
import PeopleList from '../components/PeopleList';

export default class PeopleListBox extends React.Component {
  loadPeopleListFromServer(callback) {
    $.ajax({
      url: `${this.props.url}?sync=${window.syncResult}`,
      dataType: 'json',
      cache: false,
      success: data => {
        this.setState({data: []});
        this.setState({data});
        EventEmitter.dispatch("showResultPanel");
        if (callback) {
          callback();
        }
      },
      error: (xhr, status, err) => {
        console.error(this.props.url, status, err.toString());
      }
    });
  }

  state = {
    data: []
  }

  componentDidMount() {
    this.loadPeopleListFromServer();
    EventEmitter.subscribe("refreshUsers", this.loadPeopleListFromServer);
    EventEmitter.subscribe("switchUserRoles", this.loadPeopleListFromServer);
  }

  render() {
    return (
      <div className="panel panel-default">
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