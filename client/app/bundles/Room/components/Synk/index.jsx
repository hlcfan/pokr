import PropTypes from 'prop-types'
import React from 'react'
import EventEmitter from 'libs/eventEmitter'
import Helper from 'libs/helper'

export default class Synk extends React.Component {

  componentWillReceiveProps = (nextProps) => {
    let tickets = {}
    nextProps.tickets.forEach(ticket => {
      tickets[ticket.link] = ticket
    })
    console.dir(nextProps.tickets)
    this.state = {
      tickets: tickets
    }
  }

  ticketSynked = (data) => {
    // alert(`${data.link}===${this.props.link}`)
    // alert(Helper.jiraTicketUrlForClient(data.link))
    const ticketClientUrl = Helper.jiraTicketUrlForClient(data.link)
    let newTickets = this.state.tickets
    // alert("first key" + Object.keys(newTickets)[0])
    let theTicket = newTickets[ticketClientUrl]
    theTicket["synked"] = true
    let newState = {
      tickets: newTickets
    }
    // alert(`new: ${newState}`)
    this.setState(newState)
    // if(Helper.jiraTicketUrlForClient(data.link) === this.props.link) {
    //   this.setState({synked: true})
    // }
  }

  componentDidMount() {
    EventEmitter.subscribe("ticketSynked", this.ticketSynked)
    $('#synk-credential .modal').on('hidden.bs.modal', (e) => {
      // this.setState({
      //   username: "",
      //   password: ""
      // })
    })
  }

  isJiraAccountSetup = () => {
    return !$.isEmptyObject(Cookies.get("jira_username")) &&
      !$.isEmptyObject(Cookies.get("jira_password"))
  }

  saveCredential = () => {
    if(this.usernameInput.value.length && this.passwordInput.value.length) {
      // TODO: Encrypt password at local
      Cookies.set("jira_username", this.usernameInput.value, { expires: 7 })
      Cookies.set("jira_password", this.passwordInput.value, { expires: 7 })
      Cookies.set("jira_field", this.fieldInput.value, { expires: 7 })
      // $("#synk-credential .modal").modal("hide")
      this.props.tickets.forEach((ticket) => {
        // alert(`Ticket: ${Helper.jiraTicketUrlForApi(ticket.link)}`)
        // alert(ticket.point)
        let ticketPoint = isNaN(ticket.point) ? ticket.point : parseFloat(ticket.point)
        window.Bridge.updateIssue({
          roomId: this.props.roomId,
          link: Helper.jiraTicketUrlForApi(ticket.link),
          point: ticketPoint,
          field: this.fieldInput.value,
          auth: {
            username: this.usernameInput.value,
            password: this.passwordInput.value
          }
        })
      })
    }
  }

  render() {
    const defaultUsername = Cookies.get("jira_username")
    const defaultPassword = Cookies.get("jira_password")
    const defaultField = Cookies.get("jira_field")
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
                <h4 className="modal-title">Sync to Jira</h4>
              </div>
              <div className="modal-body">
                <div className="alert alert-info" role="alert">We won't store your credential at server side. Instead, it's stored in your browser cookies.</div>
                <div className="row">
                  <div className="col-md-4">
                    <form>
                      <div className="form-group">
                        <label htmlFor="credential-username">Username</label>
                        <input type="text"
                          ref={c => this.usernameInput = c}
                          id="credential-username"
                          className="form-control"
                          placeholder="Username"
                          defaultValue={defaultUsername} />
                      </div>
                      <div className="form-group">
                        <label htmlFor="credential-password">Password</label>
                        <input type="text"
                          ref={c => this.passwordInput = c}
                          className="form-control"
                          id="credential-password"
                          placeholder="Password"
                          defaultValue={defaultPassword} />
                      </div>
                      <div className="form-group">
                        <label htmlFor="credential-field">Field</label>
                        <input type="text"
                          ref={c => this.fieldInput = c}
                          className="form-control"
                          id="credential-field"
                          placeholder="Field to update"
                          defaultValue={defaultField} />
                      </div>
                      <button type="button" className="btn btn-default" onClick={this.saveCredential}>Sync</button>
                    </form>
                  </div>
                  <div className="col-md-8">
                    <table className="table">
                      <thead><tr><th>Ticket</th><th>Sync status</th></tr></thead>
                      <tbody>
                        {tickets}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" className="btn btn-info" onClick={this.saveCredential}>Save</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
