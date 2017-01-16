var PeopleList = React.createClass({
  render: function() {
    var peopleNodes = this.props.data.map(function(person) {
      return (
        <Person key={person.id} name={person.name} id={person.id} role={person.display_role.toLowerCase()} points={person.points} voted={person.voted} avatar={person.avatar_thumb} />
      );
    });
    return (
      <div className="people-list col-md-12">
        <ul className="list-unstyled">
          {peopleNodes}
        </ul>
      </div>
    );
  }
});