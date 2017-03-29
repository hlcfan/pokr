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
    var originalTitle = "Copy to clipboard";
    $('[data-toggle="tooltip"]').tooltip({container: "#tooltip-area", title: originalTitle})
      .on("click", function() {
        $(this).attr("title", "Copied!").tooltip("fixTitle").tooltip("show");
      }).mouseleave(function() {
        $(this).attr("title", originalTitle).tooltip("fixTitle");
      });

    EventEmitter.subscribe("roomClosed", this.removeOperationButtons);
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

    var copyLink = function() {
      var aField = document.getElementById("hiddenField");
      aField.hidden   = false;
      aField.value    = window.location.href;
      aField.select();
      document.execCommand("copy");
      aField.hidden = true;
    }

    var operationButtons = function() {
      if (POKER.role === 'Moderator' && POKER.roomState !== "draw") {
        return(
          <div className="btn-group pull-right room-operation" role="group">
            {roomStatusButton}
            <a href={"/rooms/"+ POKER.roomId + "/edit"} className="btn btn-default">Edit room</a>
            <button type="button" onClick={copyLink} className="btn btn-default" data-toggle="tooltip" data-placement="bottom">Share link</button>
          </div>
        )
      }
    }();

    return (
      <div className="name">
        <div className="col-md-8">
          <h3 className="pull-left">{POKER.roomName}</h3>
          {operationButtons}
          <div id="tooltip-area"></div>
        </div>
        <div className="col-md-4">
          <h3><i className="pull-right">Yo, {POKER.currentUser.name}({POKER.role})!</i></h3>
        </div>
        <input type="text" id="hiddenField" className="room--share-link" />
      </div>
    );
  }
});