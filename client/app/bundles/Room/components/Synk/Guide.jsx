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
                <h4 className="modal-title">Install Chrome extension - Pokrex JIRA Assistant</h4>
              </div>
              <div className="modal-body">
                <h4>
                  Install Chrome extension to update points to JIRA within 1 minute
                </h4>
                <ol>
                  <li><a href="/pokrex-chrome-extention-pack.zip"><b>Download</b></a> and extract extension zip file (95kb)</li>
                  <li>Open URL: <b>chrome://extensions/</b> in Chrome</li>
                  <li><b>Drag</b> extracted extension folder into the page</li>
                </ol>
                <img className={css["installation-screenshot"]} src="/installachromeextension.png" alt="drag and install extension"/>
              </div>
              <div className="panel-footer">
                <div className="alert alert-success" role="alert">
                  <p><i className="fa fa-question-circle"></i> Because the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS" target="_blank">CORS policy</a>, Pokrex cannot send/receive data from JIRA, thus we have to create browser extension to send/receive data to JIRA from your browser. It's totally secure, we do not store any of your credentials, all requests are made locally.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
