import PropTypes from 'prop-types'
import React from 'react'
import {HOC} from './hoc'
import StoryList from '../StoryList'
import EventEmitter from 'libs/eventEmitter'
import {defaultTourColor} from 'libs/barColors'
import css from './index.scss'

class StoryListBoxMobile extends React.Component {
  componentDidMount() {
    this.props.loadStoryListFromServer()
    EventEmitter.subscribe("refreshStories", this.props.loadStoryListFromServer)

    this.props.addSteps({
      title: 'Stories',
      text: 'Showing current story, click ⏬ to see all stories',
      selector: '#stories',
      position: 'top-right',
      style: defaultTourColor
    })
  }

  render() {
    const defaultArray = [];
    const ticketHeading = (() => {
      if (this.props.data.ungroomed && this.props.data.ungroomed.length) {
        return this.props.data.ungroomed[0].link
      } else if(this.props.data.groomed && this.props.data.groomed.length) {
        return "Room closed..."
      } else {
        return "Loading..."
      }
    })();

    return (
      <div className="panel panel-default" id="stories">
        <div className="panel-heading">
          <span className={css['stories--ongoing']}></span>
          <a href={storyLinkHref(ticketHeading)} target="_blank">{ticketHeading}</a>
          <a className="pull-right"
            data-toggle="collapse"
            data-parent="#accordion"
            href="#storyListArea">
            ⏬
          </a>
        </div>
        <div id="storyListArea" className="panel-body row panel-collapse collapse">
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

const StoryListBox = HOC(StoryListBoxMobile)
export default StoryListBox;