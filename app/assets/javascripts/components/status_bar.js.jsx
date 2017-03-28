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
    $(".room-operation").remove();
  },
  componentDidMount: function() {
    EventEmitter.subscribe("roomClosed", this.removeOperationButtons);
  },
  beWatcher: function() {
    if (POKER.role === "Watcher")
      return

    alert("Be watcher")
  },
  beParticipant: function() {
    if (POKER.role === "Participant")
      return

    alert("Be participant")
  },
  render:function() {
    var that = this;
    var roomStatusButton = function() {
      var buttonText = "Close it";
      var buttonClassName = "btn-warning close-room";
      var onClickHandler = that.closeRoom;
      
      return (
        <button type="button" onClick={onClickHandler} className={"btn btn-default " + buttonClassName}>{buttonText}</button>
      )
    }();

    var operationButtons = function() {
      if (POKER.role === 'Moderator' && POKER.roomState !== "draw") {
        return(
          <div className="btn-group pull-right room-operation" role="group">
            <a href={"/rooms/"+ POKER.roomId + "/edit"} className="btn btn-default">Edit room</a>
            {roomStatusButton}
          </div>
        )
      }
    }();

    var userRoleClassName = function(role) {
      if(POKER.role === "Moderator")
        return

      if (POKER.role === role ) {
        return "disabled";
      } else {
        return "";
      }
    };

    return (
      <div className="name">
        <div className="col-md-8">
          <h3 className="pull-left">{POKER.roomName}</h3>
          {operationButtons}
        </div>
        <div className="col-md-4">
          <div className="dropdown pull-right">
            <button className="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
              🤖&nbsp; {POKER.role} &nbsp;
              <span className="caret"></span>
            </button>
            <ul className="dropdown-menu" aria-labelledby="dropdownMenu1">
              <li className={userRoleClassName("Watcher")}><a onClick={this.beWatcher} href="javascript:;">Be watcher 😎</a></li>
              <li className={userRoleClassName("Participant")}><a onClick={this.beParticipant} href="javascript:;">Be participant 👷</a></li>
              <li role="separator" className="divider"></li>
              <li><a href="#">Quit</a></li>
            </ul>
          </div>
        </div>
      </div>
    );
  }
});