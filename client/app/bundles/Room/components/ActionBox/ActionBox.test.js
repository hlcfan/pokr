import React from 'react'
import ActionBox from './ActionBox'
import renderer from 'react-test-renderer'
import { shallow } from 'enzyme';
import sinon from 'sinon';

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
  ).toJSON()

  expect(tree).toMatchSnapshot()
})

test("shows the vote results when click Flip button", () => {
  global.App = { rooms: { perform: function() { } } }

  const addSteps = sinon.spy()
  const component = shallow(
    <ActionBox
      roomId="test-room"
      storyId={1}
      roomState="not-open"
      role="Moderator"
      countDown={10}
      addSteps={addSteps}
      />
  )
  component.find('.flip').simulate('click');

  expect(component.find('.openButton .btn')).toHaveLength(2);
  expect(component.find('.result-panel')).toHaveLength(1);
})