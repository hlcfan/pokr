var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;
var StoryList = React.createClass({
  render: function() {
    var tab = this.props.tab;
    var storyNodes = this.props.data.map(function(story) {
      return (
        <Story key={story.id} id={story.id} link={story.link} desc={story.desc} tab={tab} />
      );
    });
    return (
      <div className="storyList col-md-12">
        <ul>
          <ReactCSSTransitionGroup transitionName="story" transitionEnterTimeout={500} transitionLeaveTimeout={300}>
            {storyNodes}
          </ReactCSSTransitionGroup>
        </ul>
      </div>
    );
  }
});