import PropTypes from 'prop-types'
import React from 'react'
import {HOC} from './hoc'
import StoryList from '../StoryList'
import EventEmitter from 'libs/eventEmitter'
import {defaultTourColor} from 'libs/barColors'

class StoryListBoxDesktop extends React.Component {
  componentDidMount() {
    this.props.loadStoryListFromServer()
    EventEmitter.subscribe("refreshStories", this.props.loadStoryListFromServer)

    this.props.addSteps({
      title: 'Stories',
      text: 'All your stories are listed here.',
      selector: '#stories',
      position: 'top-right',
      style: defaultTourColor
    })

    this.props.addSteps({
      title: 'Current story',
      text: "The ► indicates the current story.",
      selector: '#stories .story__ungroomed:first-child',
      position: 'bottom-left',
      style: defaultTourColor
    })
  }

  render() {
    const defaultArray = [];
    return (
      <div className="panel panel-default" id="stories">
        <div className="panel-heading">Stories</div>
        <div id="storyListArea" className="panel-body row">
          <ul className="nav nav-tabs" role="tablist">
            <li role="presentation" className="active">
              <a href="#grooming-list" aria-controls="home" role="tab" data-toggle="tab">Pending</a>
            </li>
            <li role="presentation">
              <a href="#groomed-list" aria-controls="profile" role="tab" data-toggle="tab">Finished</a>
            </li>
          </ul>
          <div className="tab-content">
            <div role="tabpanel" className="row storyListBox tab-pane active" id="grooming-list">
              <StoryList roomState={this.props.roomState} roomId={this.props.roomId} role={this.props.role} data={this.props.data.ungroomed || defaultArray} tab="ungroomed" />
            </div>
            <div role="tabpanel" className="tab-pane" id="groomed-list">
              <StoryList roomState={this.props.roomState} roomId={this.props.roomId} role={this.props.role} data={this.props.data.groomed || defaultArray} tab="groomed" />
            </div>
          </div>
        </div>
      </div>
    )
  }
}

const StoryListBox = HOC(StoryListBoxDesktop)
export default StoryListBox