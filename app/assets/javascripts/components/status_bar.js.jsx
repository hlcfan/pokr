var StatusBar = React.createClass({
  getInitialState: function() {
    return { role: POKER.role };
  },
  openRoom: function() {
  },
  closeRoom: function() {
    if(confirm("Do you want to close this room? It can not be undo!")) {
      App.rooms.perform('action', {
        roomId: POKER.roomId,
        data: "close-room",
        type: 'action'
      });
    }
  },
  removeOperationButtons: function() {
    $(".room-operation").remove();
  },
  componentDidMount: function() {
    var originalTitle = "Copy to clipboard";
    $('[data-toggle="tooltip"]').tooltip({container: "#tooltip-area", title: originalTitle})
      .on("click", function() {
        $(this).attr("title", "Copied!").tooltip("fixTitle").tooltip("show");
      }).mouseleave(function() {
        $(this).attr("title", originalTitle).tooltip("fixTitle");
      });

    EventEmitter.subscribe("roomClosed", this.removeOperationButtons);
  },
  beWatcher: function() {
    if (POKER.role === "Watcher")
      return

    $.ajax({
      url: "/rooms/"+POKER.roomId+"/switch_role",
      cache: false,
      type: 'POST',
      data: {role: WATCHER_ROLE},
      success: function(data) {
        console.log("Switch role to watcher!");
        EventEmitter.dispatch("switchUserRoles");
        POKER.role = "Watcher";
        this.setState({role: "Watcher"});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("Switch role failed!");
      }.bind(this)
    });
  },
  beParticipant: function() {
    if (POKER.role === "Participant")
      return

    $.ajax({
      url: "/rooms/"+POKER.roomId+"/switch_role",
      cache: false,
      type: 'POST',
      data: {role: PARTICIPANT_ROLE},
      success: function(data) {
        console.log("Switch role to participant!");
        EventEmitter.dispatch("switchUserRoles");
        POKER.role = "Participant";
        this.setState({role: "Participant"});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("Switch role failed!");
      }.bind(this)
    });
  },
  render:function() {
    var that = this;
    var roomStatusButton = function() {
      if(POKER.role === 'Moderator') {
        var buttonText = "🏁 Close it";
        var buttonClassName = "btn-warning close-room";
        var onClickHandler = that.closeRoom;

        return (
          <button type="button" onClick={onClickHandler} className={"btn btn-default " + buttonClassName}>{buttonText}</button>
        )
      }
    }();

    var editButton = function() {
      if(POKER.role === 'Moderator') {
        return(
          <a href={"/rooms/"+ POKER.roomId + "/edit"} className="btn btn-default">✏️ Edit room</a>
        )
      }
    }();

    var copyLink = function() {
      var aField = document.getElementById("hiddenField");
      aField.hidden   = false;
      aField.value    = window.location.href;
      aField.select();
      document.execCommand("copy");
      aField.hidden = true;
    }

    var operationButtons = function() {
      if (POKER.roomState !== "draw") {
        return(
          <div className="btn-group pull-right room-operation" role="group">
            {roomStatusButton}
            {editButton}
            <button type="button" onClick={copyLink} className="btn btn-default" data-toggle="tooltip" data-placement="bottom">📻 Share link</button>
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
          <div id="tooltip-area"></div>
        </div>
        <div className="col-md-4">
          <div className="dropdown pull-right">
            <button className="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
              🤖&nbsp; {POKER.role} &nbsp;
              <span className="caret"></span>
            </button>
            <ul className="dropdown-menu" aria-labelledby="dropdownMenu1">
              <li className={userRoleClassName("Watcher")}><a onClick={this.beWatcher} href="javascript:;">Be watcher 👲</a></li>
              <li className={userRoleClassName("Participant")}><a onClick={this.beParticipant} href="javascript:;">Be participant 👷</a></li>
              <li role="separator" className="divider"></li>
              <li><a href="#">Quit</a></li>
            </ul>
          </div>
        </div>
        <input type="text" id="hiddenField" className="room--share-link" />
      </div>
    );
  }
});