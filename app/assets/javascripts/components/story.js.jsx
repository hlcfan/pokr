var Story = React.createClass({
  // rawMarkup: function() {
  //   var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
  //   return { __html: rawMarkup };
  // },
  revote: function(e) {
    var revoteStoryId = $(e.target).parents("li").data("id");
    if (POKER.role === 'Moderator') {
      App.rooms.perform('revote', {
        roomId: POKER.roomId,
        data: { story_id: revoteStoryId }
      });
    }
  },
  render: function() {
    var that = this;
    var revoteIcon, liElementClass;
    revoteIcon = function() {
      if (POKER.role === 'Moderator' && that.props.tab === "groomed") {
        return(
          <a href="javascript:;" className="revote" onClick={that.revote}>
            <i className="fa fa-refresh"></i>
          </a>
        )
      }
    }();

    liElementClass = function() {
      if (that.props.tab === "groomed") {
        return("story story__groomed");
      } else {
        return("story story__ungroomed");
      }
    }();

    return (
      <li className={liElementClass} id={'story-' + this.props.id} data-id={this.props.id}>
        <a href={this.props.link} className="storyLink" rel="noreferrer" target="_blank">
          {this.props.link}
        </a>
        <span className="label label-info story--voted-point">{this.props.point}</span>
        {revoteIcon}
        <p className="story-desc">
          {this.props.desc}
        </p>
      </li>
    );
  }
});