var Person = React.createClass({
  render: function() {
    var userIconClass;
    if (this.props.role === 'watcher') {
      userIconClass = 'fa fa-user fa-user-secret';
    } else {
      userIconClass = 'fa fa-user';
    }

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
      <li className={'person ' + votedClass} id={'u-' + this.props.id} data-point={this.props.points}>
        <i className={this.props.role + ' ' + userIconClass} aria-hidden="true"></i>
        <a href="javascript:;" className="person">
          {this.props.name}
          {pointLabel}
        </a>
      </li>
    );
  }
});