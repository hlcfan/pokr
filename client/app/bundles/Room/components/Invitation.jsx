import PropTypes from 'prop-types'
import React from 'react'

export default class Invitation extends React.Component {
  static propTypes = {
    roomId: PropTypes.string
  }

  state = {
    emails: ["", "", ""],
    sent: false
  }

  componentDidMount() {
    $('#invitation .modal').on('hidden.bs.modal', (e) => {
      if (this.state.sent) {
        this.setState({
          emails: ["", "", ""],
          sent: false
        })
      }
    })
  }

  addEmail = () => {
    let emails = this.state.emails
    emails.push("")

    this.setState(prevState => {
      return {
        emails: emails
      }
    })
  }

  onRemove = (index) => {
    let emails = this.state.emails
    if (emails.length === 1) {
      return false
    }
    emails.splice(index, 1)

    this.setState(prevState => {
      return {
        emails: emails,
        sent: prevState.sent
      }
    })
  }

  handleEmailChange = (event) => {
    let emails = this.state.emails
    let inputIndex = event.target.dataset.index
    emails[inputIndex] = event.target.value

    this.setState(prevState => {
      return {
        emails: emails,
        sent: prevState.sent
      }
    })
  }

  sendInvitation = () => {
    $.ajax({
      url: `/rooms/${this.props.roomId}/invite`,
      type: 'POST',
      data: { emails: this.state.emails },
      cache: false,
      success: data => {
        this.setState(prevState => {
          return {
            emails: prevState.emails,
            sent: true
          }
        })
      },
      error: (xhr, status, err) => {
        console.error("Fetching people list", status, err.toString());
      }
    })
  }

  emailForm = () => {
    const emailFields = this.state.emails.map((email, index) => {
      return(
        <div className="row" key={`${email}-${index}`}>
          <div className="col-xs-8">
            <label>Email address</label>
            <div className="row">
              <div className="col-xs-11">
                <input type="email"
                  className="form-control"
                  name="email"
                  placeholder="Email"
                  defaultValue={email}
                  onBlur={this.handleEmailChange}
                  data-index={index}
                  />
              </div>
              {
                this.state.emails.length > 1 &&
                  <div className="col-xs-1 remove">
                    <a href="javascript:;" onClick={(index) => this.onRemove(index)}><i className="fa fa-trash-o fa-3"></i></a>
                  </div>
              }
            </div>
          </div>
        </div>
      )
    })

    return(
      <form method="post" action={`/rooms/${this.props.roomId}/invite`}>
        <div className="form-group">
          {emailFields}
          <div className="row add">
            <div className="col-xs-8">
              <a href="javascript:;" onClick={this.addEmail}><i className="fa fa-plus-circle"></i> Add another</a>
            </div>
          </div>
        </div>
      </form>
    )
  }

  emailSent = () => {
    return(
      <div>
        <h4 className="invitation--sent">Your invitation has been sent!</h4>
        <table className="table">
          <thead>
            <tr>
              <th>Email Address</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>alex.shi@gmail.com</th>
            </tr>
          </tbody>
        </table>
      </div>
    )
  }

  // resetForm = () => {
  //   $('#invitation .modal').modal('hide')
  // }

  render() {
    const invitationContent = () => {
      if (this.state.sent) {
        return(this.emailSent())
      } else {
        return(this.emailForm())
      }
    }

    const invitationIconStatus = () => {
      if (this.state.sent) {
        return "invitation__icon--on"
      } else {
        return ""
      }
    }

    return (
      <div id="invitation">
        <div className="modal fade" tabIndex="-1" role="dialog">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title"><i className={`fa fa-paper-plane ${invitationIconStatus()}`}></i> Invite members</h4>
              </div>
              <div className="modal-body">
                {invitationContent()}
              </div>
              <div className="modal-footer">
                {
                  !this.state.sent &&
                   <button type="button" className="btn btn-info pull-left" onClick={this.sendInvitation}>Send Invitations</button>
                }
                <button type="button" className="btn btn-default" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}