var PeopleListBox = React.createClass({
  loadPeopleListFromServer: function(callback) {
    $.ajax({
      url: this.props.url + '?sync=' + window.syncResult,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: data});
        if (callback) {
          callback();
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {data: []};
  },
  beforeShown: function() {
    this.loadPeopleListFromServer(function() {
      EventEmitter.dispatch("resultShown");
    });
  },
  componentDidMount: function() {
    if (!window.syncResult) {
      this.loadPeopleListFromServer();
    }
    EventEmitter.subscribe("storySwitched", this.loadPeopleListFromServer);
    EventEmitter.subscribe("refreshUsers", this.loadPeopleListFromServer);
    EventEmitter.subscribe("beforeResultShown", this.beforeShown);
  },
  render: function() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">People</div>
        <div id="peopleListArea" className="panel-body row">
          <div className="peopleListBox">
            <PeopleList data={this.state.data} />
          </div>
        </div>
      </div>
    );
  }
});