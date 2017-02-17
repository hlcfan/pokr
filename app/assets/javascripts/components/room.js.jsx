var Room = React.createClass({
  rawMarkup: function() {
    var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
    return { __html: rawMarkup };
  },
  getInitialState: function() {
    return { storyListUrl: this.props.poker.storyListUrl, peopleListUrl: this.props.poker.peopleListUrl };
  },
  roomClosed: function() {
    console.log("closed");
    POKER.roomState = "draw";
    drawBoard();
  },
  componentDidMount: function() {
    if (POKER.roomState === "draw") {
      drawBoard();
    } else {
      EventEmitter.subscribe("roomClosed", this.roomClosed);
    }
  },
  render: function() {
    return (
      <div className="row">
        <StatusBar />
        <div id="operationArea" className="col-md-8">
          <VoteBox poker={POKER}/>
          <StoryListBox url={this.props.poker.storyListUrl} />
        </div>

        <div className="col-md-4">
          <PeopleListBox url={this.props.poker.peopleListUrl} />
          <ActionBox />
        </div>
      </div>
    );
  }
});