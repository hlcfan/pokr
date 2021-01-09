import PropTypes from 'prop-types';
import React from 'react';
import Story from '../components/Story';

export default class StoryList extends React.Component {
  render() {
    const tab = this.props.tab;
    const storyNodes = this.props.data.map(story =>
      <Story
        key={story.id}
        id={story.id}
        link={story.link}
        desc={story.desc}
        point={story.point}
        tab={tab}
        roomId={this.props.roomId}
        role={this.props.role}
        roomState={this.props.roomState}
      />)
    return (
      <div className="storyList col-md-12">
        <ul>
          {storyNodes}
        </ul>
      </div>
    )
  }
}
