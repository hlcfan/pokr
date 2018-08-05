import PropTypes from 'prop-types'
import React from 'react'

import css from './Guide.scss'

export default class Guide extends React.Component {
  render() {
    return(
      <div id="synk-guide" className={css["synk-guide"]}>
        <div className="modal fade" tabIndex="-1" role="dialog">
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title">Instruction to sync to JIRA</h4>
              </div>
              <div className="modal-body">
                <h3 className={`${css["installation-link"]} text-center`}>
                  <a href="https://pokrex.com/apps?from_room" target="_blank">Install app and start sync within 2 minutes</a>
                </h3>
              </div>
              <div className="panel-footer">
                <div classNam="alert alert-success" role="alert">
                  <p><i className="fa fa-question-circle"></i> Because the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS" target="_blank">CORS policy</a>, Pokrex cannot send/receive data from JIRA, thus we have to create desktop applications to send/receive data to JIRA from your computer, just like what you do in browser. It's totally secure, we do not store any of your credentials, all requests are made locally.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
