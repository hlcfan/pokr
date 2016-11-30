var Story = React.createClass({
  // rawMarkup: function() {
  //   var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
  //   return { __html: rawMarkup };
  // },

  render: function() {
    var that = this;
    var revoteIcon;
    revoteIcon = function() {
      if (that.props.tab === "groomed") {
        return(
          <a href="javascript:;" className="revote" onClick={that.revote}>
            <i className="fa fa-refresh"></i>
          </a>
        )
      }
    }();

    return (
      <li className="story" id={'story-' + this.props.id} data-id={this.props.id}>
        <a href={this.props.link} className="storyLink" rel="noreferrer" target="_blank">
          {this.props.link}
        </a>
        {revoteIcon}
        <p className="story-desc">
          {this.props.desc}
        </p>
      </li>
    );
  }
});