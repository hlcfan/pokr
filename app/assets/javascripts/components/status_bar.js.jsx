var StatusBar = React.createClass({
  render:function(){
    return (
      <div className="name">
        <div className="col-md-8">
          <h3 className="pull-left">{POKER.roomName}</h3>
          <div className="btn-group pull-right" role="group" aria-label="...">
            <button type="button" className="btn btn-default">Edit</button>
            <button type="button" className="btn btn-default btn-warning">Close</button>
          </div>
        </div>
        <div className="col-md-4">
          <h3><i className="pull-right">Yo, {POKER.currentUser.name}({POKER.role})!</i></h3>
        </div>
      </div>
    );
  }
});