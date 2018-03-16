import PropTypes from 'prop-types'
import React from 'react'
import Person from '../components/Person'

export default class PeopleList extends React.Component {
  render() {
    const peopleNodes = this.props.data.map(person =>
      <Person
        key={person.id}
        name={person.name}
        id={person.id}
        role={person.display_role.toLowerCase()}
        points={person.points}
        voted={person.voted}
        avatar={person.avatar_thumb}
        role={this.props.role}
        editable={this.props.editable}
        roomId={this.props.roomId}
        currentUserId={this.props.currentUserId}
      />
    )

    return (
      <div className="people-list col-md-12">
        <ul className="list-unstyled">
          {peopleNodes}
        </ul>
      </div>
    )
  }
}