import React from 'react'
import ActionBox from './ActionBox'
import renderer from 'react-test-renderer'

it('renders correctly', () => {
  const addSteps = jest.fn()
  const tree = renderer.create(
    <ActionBox
      roomId="test-room"
      storyId={1}
      roomState="open"
      role="Moderator"
      countDown={10}
      addSteps={addSteps}
      />
  ).toJSON();

  expect(tree).toMatchSnapshot();
});