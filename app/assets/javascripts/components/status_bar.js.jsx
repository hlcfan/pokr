var StatusBar = React.createClass({
  render:function(){
    return (
      <h3>
        {POKER.roomName}
        <i className="pull-right">Yo, {POKER.currentUser.name}({POKER.role})!</i>
      </h3>
    );
  }
});