import PropTypes from 'prop-types';
import React from 'react';
import Story from '../components/Story';
import CSSTransitionGroup from 'react-transition-group/CSSTransitionGroup'

export default class StoryList extends React.Component {
  render() {
    const tab = this.props.tab;
    const storyNodes = this.props.data.map(story => <Story key={story.id} id={story.id} link={story.link} desc={story.desc} point={story.point} tab={tab} />);
    return (
      <div className="storyList col-md-12">
        <ul>
          <CSSTransitionGroup transitionName="story" transitionEnterTimeout={500} transitionLeaveTimeout={300}>
            {storyNodes}
          </CSSTransitionGroup>
        </ul>
      </div>
    )
  }
}