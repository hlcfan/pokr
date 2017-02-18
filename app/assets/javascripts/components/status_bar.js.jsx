var StatusBar = React.createClass({
  openRoom: function() {
  },
  closeRoom: function() {
    App.rooms.perform('action', {
      roomId: POKER.roomId,
      data: "close-room",
      type: 'action'
    });
  },
  removeOperationButtons: function() {
    $(".btn-group").remove();
  },
  componentDidMount: function() {
    EventEmitter.subscribe("roomClosed", this.removeOperationButtons);
  },
  render:function() {
    var that = this;
    var roomStatusButton = function() {
      var buttonText, buttonClassName, onClickHandler;
      if (POKER.roomState === "draw") {
        buttonText = "Re-open it";
        buttonClassName = "btn-warning open-room";
        onClickHandler = that.openRoom;
      } else {
        buttonText = "Close it";
        buttonClassName = "btn-warning close-room";
        onClickHandler = that.closeRoom;
      }
      return (
        <button type="button" onClick={onClickHandler} className={"btn btn-default " + buttonClassName}>{buttonText}</button>
      )
    }();

    var operationButtons = function() {
      if (POKER.role === 'Moderator' && POKER.roomState !== "draw") {
        return(
          <div className="btn-group pull-right" role="group">
            <a href={"/rooms/"+ POKER.roomId + "/edit"} className="btn btn-default">Edit room</a>
            {roomStatusButton}
          </div>
        )
      }
    }();

    return (
      <div className="name">
        <div className="col-md-8">
          <h3 className="pull-left">{POKER.roomName}</h3>
          {operationButtons}
        </div>
        <div className="col-md-4">
          <h3><i className="pull-right">Yo, {POKER.currentUser.name}({POKER.role})!</i></h3>
        </div>
      </div>
    );
  }
});