var StoryListBox = React.createClass({
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
    return {data: []};
  },
  componentDidMount: function() {
    this.loadStoryListFromServer();
    EventEmitter.subscribe("refreshStories", this.loadStoryListFromServer);
  },
  componentDidUpdate: function() {
    $currentStory = $('.storyList ul li.story__ungroomed').not(".story-leave").first();
    if($currentStory.length) {
      POKER.story_id = $currentStory.data('id');
    } else {
      POKER.story_id = "";
      if (!POKER.freeStyle) {
        EventEmitter.dispatch("noStoriesLeft");
        drawBoard();
      }
    }
  },
  render: function() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">Stories</div>
        <div id="storyListArea" className="panel-body row">
          <ul className="nav nav-tabs" role="tablist">
            <li role="presentation" className="active">
              <a href="#grooming-list" aria-controls="home" role="tab" data-toggle="tab">Groom list</a>
            </li>
            <li role="presentation">
              <a href="#groomed-list" aria-controls="profile" role="tab" data-toggle="tab">Groomed list</a>
            </li>
          </ul>
          <div className="tab-content">
            <div role="tabpanel" className="row storyListBox tab-pane active" id="grooming-list">
              <StoryList data={this.state.data.ungroomed || []} tab="ungroomed" />
            </div>
            <div role="tabpanel" className="tab-pane" id="groomed-list">
              <StoryList data={this.state.data.groomed || []} tab="groomed" />
            </div>
          </div>
        </div>
      </div>
    );
  }
});