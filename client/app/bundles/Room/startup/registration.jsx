import ReactOnRails from 'react-on-rails';

import Room from '../containers/Room'
import RoomMobile from '../containers/RoomMobile'

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
  Room, RoomMobile
});