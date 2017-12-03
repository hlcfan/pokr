import PropTypes from 'prop-types'
import React from 'react'
import StoryList from '../StoryList'
import EventEmitter from 'libs/eventEmitter'
import {defaultTourColor} from 'libs/barColors'

export const HOC = (WrappedComponent) => class extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      data: []
    }
  }

  loadStoryListFromServer = () => {
    $.ajax({
      url: `/rooms/${this.props.roomId}/story_list.json`,
      dataType: 'json',
      cache: false,
      success: data => {
        if (data["ungroomed"].length) {
          let nextStoryId = data["ungroomed"][0]["id"]
          if (this.props.storyId !== nextStoryId) {
            this.handleStorySwitch(nextStoryId)
          }
        } else {
          this.handleNoStoryLeft()
        }
        this.setState({ data })
      },
      error: (xhr, status, err) => {
        console.error("Fetching story list", status, err.toString());
      }
    });
  }

  handleStorySwitch = (storyId) => {
    this.props.onSwitchStory(storyId)
  }

  handleNoStoryLeft = () => {
    this.props.onNoStoryLeft()
  }

  render = () => {
    return(
      <WrappedComponent {...this.props}
        {...this.state}
        loadStoryListFromServer={this.loadStoryListFromServer}
      />
    )
  }
}
