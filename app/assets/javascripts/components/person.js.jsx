var Person = React.createClass({
  render: function() {
    var that = this;
    var pointLabel = (function() {
      if (window.syncResult) {
        return(
          <span className="points pull-right">
            {pointEmojis[that.props.points] || that.props.points}
          </span>
        );
      }
    })();

    var votedClass = '';
    if (this.props.voted) {
      votedClass = 'voted';
    }

    return (
      <li className={this.props.role + ' ' + 'person ' + votedClass} id={'u-' + this.props.id} data-point={this.props.points}>
        <i className="person--avatar">
          <img src={this.props.avatar} />
        </i>
        <a href="javascript:;" className="person">
          {this.props.name}
          {pointLabel}
        </a>
      </li>
    );
  }
});