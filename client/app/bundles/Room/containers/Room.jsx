import PropTypes from 'prop-types';
import React from 'react';
import StatusBar from '../components/StatusBar';
import VoteBox from '../components/VoteBox';
import StoryListBox from '../components/StoryListBox';
import PeopleListBox from '../components/PeopleListBox';
import ActionBox from '../components/ActionBox';
import ActionCable from 'libs/actionCable'

export default class Room extends React.Component {
  rawMarkup() {
    const rawMarkup = marked(this.props.children.toString(), {sanitize: true});
    return { __html: rawMarkup };
  }

  constructor(props) {
    super(props)
    window.syncResult = (props.roomState == 'open') ? true : false
    ActionCable.setupChannelSubscription(props.roomId, props.roomState)

    this.state = {
      roomState: props.roomState,
      currentStoryId: props.currentStoryId
    }
  }

  state = {
    storyListUrl: this.props.storyListUrl,
    peopleListUrl: this.props.peopleListUrl
  }

  handleStorySwitch = (storyId) => {
    this.setState({
      roomState: "not-open",
      currentStoryId: storyId
    })
  }

  handleNoStoryLeft = () => {
    this.setState({
      roomState: "draw"
    })

    // Send request to draw room
  }

  render() {
    return (
      <div className="room" id="room">
        <div className="row">
          <StatusBar roomState={this.state.roomState} role={this.props.role} roomId={this.props.roomId} roomName={this.props.roomName} />
          <div id="operationArea" className="col-md-8">
            <VoteBox roomId={this.props.roomId} roomState={this.state.roomState} currentVote={this.props.currentVote} pointValues={this.props.pointValues} />
            <StoryListBox onSwitchStory={this.handleStorySwitch} onNoStoryLeft={this.handleNoStoryLeft} url={this.props.storyListUrl} />
          </div>

          <div className="col-md-4">
            <PeopleListBox url={this.props.peopleListUrl} />
            <ActionBox
              roomState={this.state.roomState}
              role={this.props.role}
              roomId={this.props.roomId}
              storyId={this.state.currentStoryId}
              timerInterval={this.props.timerInterval} />
          </div>
        </div>
      </div>
    )
  }
}