var StatusBar = React.createClass({
  render:function(){
    var roomStatusButton = function() {
      var buttonText, buttonClassName;
      if (POKER.roomState === "draw") {
        buttonText = "Re-open it";
        buttonClassName = "btn-warning open-room";  
      } else {
        buttonText = "Close it";
        buttonClassName = "btn-warning close-room"; 
      }
      return (
        <button type="button" className={"btn btn-default " + buttonClassName}>{buttonText}</button>
      )
    }();

    var operationButtons = function() {
      if (POKER.role === 'Moderator') {
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