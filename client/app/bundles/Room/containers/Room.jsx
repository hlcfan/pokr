import PropTypes from 'prop-types';
import React from 'react';
import StatusBar from '../components/StatusBar';
import VoteBox from '../components/VoteBox';
import StoryListBox from '../components/StoryListBox';
import PeopleListBox from '../components/PeopleListBox';
import ActionBox from '../components/ActionBox';

export default class Room extends React.Component {
  rawMarkup() {
    const rawMarkup = marked(this.props.children.toString(), {sanitize: true});
    return { __html: rawMarkup };
  }
  state = {
    storyListUrl: this.props.poker.storyListUrl,
    peopleListUrl: this.props.poker.peopleListUrl
  }

  roomClosed() {
    POKER.roomState = "draw";
    drawBoard();
  }

  componentDidMount() {
    if (POKER.roomState === "draw") {
      EventEmitter.dispatch("roomClosed");
      drawBoard();
    } else {
      EventEmitter.subscribe("roomClosed", this.roomClosed);
    }
  }

  render() {
    return (
      <div className="row">
        <StatusBar />
        <div id="operationArea" className="col-md-8">
          <VoteBox poker={this.props.poker} />
          <StoryListBox url={this.props.poker.storyListUrl} />
        </div>

        <div className="col-md-4">
          <PeopleListBox url={this.props.poker.peopleListUrl} />
          <ActionBox />
        </div>
      </div>
    )
  }
}