import PropTypes from 'prop-types'
import React from 'react'
import EventEmitter from 'libs/eventEmitter'
import { jiraTicketUrlForClient, jiraTicketUrlForApi, jiraHostFromUrl } from 'libs/helper'

export default class Synk extends React.Component {

  componentWillReceiveProps = (nextProps) => {
    let tickets = {}
    nextProps.tickets.forEach(ticket => {
      tickets[ticket.link] = ticket
    })

    this.state = {
      tickets: tickets
    }
  }

  ticketSynked = (data) => {
    const ticketClientUrl = jiraTicketUrlForClient(data.link)
    let newTickets = this.state.tickets
    let theTicket = newTickets[ticketClientUrl]
    theTicket["synked"] = true
    let newState = {
      tickets: newTickets
    }
    this.setState(newState)
  }

  componentDidMount() {
    EventEmitter.subscribe("ticketSynked", this.ticketSynked)
  }

  saveCredential = () => {
    if(this.usernameInput.value.length && this.passwordInput.value.length) {
      // TODO: Encrypt password at local
      Cookies.set("jira_username", this.usernameInput.value, { expires: 7 })
      Cookies.set("jira_password", this.passwordInput.value, { expires: 7 })
      Cookies.set("jira_field", this.fieldInput.value, { expires: 7 })
      this.props.tickets.forEach((ticket) => {
        const ticketPoint = isNaN(ticket.point) ? ticket.point : parseFloat(ticket.point)
        if(ticket.link.isValidUrl()) {
          window.Bridge.updateIssue({
            roomId: this.props.roomId,
            link: jiraTicketUrlForApi(ticket.link),
            point: ticketPoint,
            field: this.fieldInput.value,
            fieldListUrl: `${jiraHostFromUrl(ticket.link)}/rest/api/2/field`,
            auth: {
              username: this.usernameInput.value,
              password: this.passwordInput.value
            }
          })
        }
      })
    }
  }

  render() {
    const defaultUsername = Cookies.get("jira_username")
    const defaultPassword = Cookies.get("jira_password")
    const defaultField = Cookies.get("jira_field") || "Story points"
    const tickets = this.props.tickets.map((ticket, index) => {
      return(
        <tr key={ticket.link}>
          <td>{ticket.link}</td>
          <td>{ticket.synked ? <i className='fa fa-check'></i> : "Not sync"}</td>
        </tr>
      )
    })

    return(
      <div id="synk-credential" className="synk-credential">
        <div className="modal fade" tabIndex="-1" role="dialog">
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title">Sync to JIRA</h4>
              </div>
              <div className="modal-body">
                <div className="row">
                  <div className="col-md-6">
                    <form className="form-horizontal">
                      <div className="form-group">
                        <label htmlFor="credential-username" className="col-sm-3 control-label">Username</label>
                        <div className="col-sm-9">
                          <input type="text"
                           ref={c => this.usernameInput = c}
                           id="credential-username"
                           className="form-control"
                           placeholder="Username"
                           defaultValue={defaultUsername} />
                        </div>
                      </div>
                      <div className="form-group">
                        <label htmlFor="credential-password" className="col-sm-3 control-label">Password</label>
                        <div className="col-sm-9">
                          <input type="password"
                           ref={c => this.passwordInput = c}
                            className="form-control"
                            id="credential-password"
                            placeholder="Password"
                            defaultValue={defaultPassword} />
                        </div>
                      </div>
                      <div className="form-group">
                        <label htmlFor="credential-field" className="col-sm-3 control-label">Field</label>
                        <div className="col-sm-9">
                          <input type="text"
                           ref={c => this.fieldInput = c}
                            className="form-control"
                            id="credential-field"
                            placeholder="Field to update"
                            defaultValue={defaultField} />
                        </div>
                      </div>
                      <div className="form-group">
                        <div className="col-sm-offset-3 col-sm-9">
                          <button type="button" className="btn btn-default" onClick={this.saveCredential}>Sync</button>
                        </div>
                      </div>
                    </form>
                  </div>
                  <div className="col-md-6">
                    <div className="alert alert-info" role="alert"><i className="fa fa-exclamation-triangle" aria-hidden="true"></i> All your credentials are stored locally. All JIRA issue update happens locally. It's safe. <b>Ticket link must be JIRA issue URL.</b></div>
                  </div>
                </div>
                <table className="table">
                  <thead><tr><th>Ticket</th><th>Sync status</th></tr></thead>
                  <tbody>
                    {tickets}
                  </tbody>
                </table>
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
