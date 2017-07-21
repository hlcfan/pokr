import PropTypes from 'prop-types'
import React from 'react'

export default class Invitation extends React.Component {
  static propTypes = {
    roomId: PropTypes.string
  }

  state = {
    status: false
  }

  componentDidMount() {
    $('#invitation .modal').modal({keyboard: false, backdrop: 'static'})
  }

  render() {
    return (
      <div id="invitation">
        <div className="modal fade" tabIndex="-1" role="dialog">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title">Invite your team</h4>
              </div>
              <div className="modal-body">

              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-default" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}