import PropTypes from 'prop-types'
import React from 'react'

export default class Synk extends React.Component {

  state = {
    username: "",
    password: ""
  }

  componentDidMount() {
    $('#synk-credential .modal').on('hidden.bs.modal', (e) => {
      // this.setState({
      //   username: "",
      //   password: ""
      // })
    })
  }

  handleUsernameChange = (event) => {
    const username = event.target.value

    this.setState(prevState => {
      return {
        username: username,
        password: prevState.password
      }
    })
  }

  handlePasswordChange = (event) => {
    const password = event.target.value

    this.setState(prevState => {
      return {
        username: prevState.username,
        password: password
      }
    })
  }

  saveCredential = () => {
    if(this.state.username.length && this.state.password.length) {
      // TODO: Encrypt password at local
      Cookies.set("jira_username", this.state.username)
      Cookies.set("jira_password", this.state.password)
      $("#synk-credential .modal").modal("hide")
    }
  }

  render() {
    const defaultUsername = Cookies.get("jira_username") || this.state.username
    const defaultPassword = Cookies.get("jira_password") || this.state.password

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
                <form>
                  <div className="alert alert-info" role="alert">We won't store your credential at server side. Instead, it's stored in your browser cookies.</div>
                  <div className="form-group">
                    <label htmlFor="credential-username">Username</label>
                    <input type="text"
                      id="credential-username"
                      className="form-control"
                      placeholder="Username"
                      defaultValue={defaultUsername}
                      onBlur={this.handleUsernameChange} />
                  </div>
                  <div className="form-group">
                    <label htmlFor="credential-password">Password</label>
                    <input type="text"
                      className="form-control"
                      id="credential-password"
                      placeholder="Password"
                      defaultValue={defaultPassword}
                      onBlur={this.handlePasswordChange} />
                  </div>
                </form>
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
