var PeopleListBox = React.createClass({
  loadPeopleListFromServer: function(callback) {
    $.ajax({
      url: this.props.url + '?sync=' + window.syncResult,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: []});
        this.setState({data: data});
        EventEmitter.dispatch("showResultPanel");
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
  componentDidMount: function() {
    this.loadPeopleListFromServer();
    EventEmitter.subscribe("refreshUsers", this.loadPeopleListFromServer);
    EventEmitter.subscribe("switchUserRoles", this.loadPeopleListFromServer);
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