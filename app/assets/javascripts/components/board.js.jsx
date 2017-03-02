var Board = React.createClass({
  rawMarkup: function() {
    var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
    return { __html: rawMarkup };
  },
  loadStoryListFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return { data: [] };
  },
  componentDidMount: function() {
    this.loadStoryListFromServer();
    $('#board .modal').modal({keyboard: false, backdrop: 'static'});
  },
  render: function() {
    var dataNodes = this.state.data.map(function(story) {
      var point = pointEmojis[story.point] || story.point;
      return (
        <tr key={story.id}>
          <td><a href={storyLinkHref(story.link)} target="_blank">{story.link}</a></td>
          <td>{point}</td>
        </tr>
      );
    });

    return (
      <div className="modal fade" tabIndex="-1" role="dialog">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 className="modal-title">Vote Result</h4>
            </div>
            <div className="modal-body">
              <table className="table table-bordered">
                <thead>
                  <tr>
                    <th>Story</th><th>Point</th>
                  </tr>
                </thead>
                <tbody>
                  {dataNodes}
                </tbody>
              </table>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-default" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
    );
  }
});