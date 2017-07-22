import PropTypes from 'prop-types'
import React from 'react'

export default class Invitation extends React.Component {
  static propTypes = {
    roomId: PropTypes.string
  }

  state = {
    emails: ["", "", ""]
  }

  componentDidMount() {
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
        emails: emails
      }
    })
  }

  render() {
    const emailFields = this.state.emails.map((email, index) => {
      return(
        <div className="row" key={`${email}-${index}`}>
          <div className="col-xs-8">
            <label>Email address</label>
            <div className="row">
              <div className="col-xs-11">
                <input type="email" className="form-control" name="email" placeholder="Email" defaultValue={email} onChange={this.changeEmail} />
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

    return (
      <div id="invitation">
        <div className="modal fade" tabIndex="-1" role="dialog">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title"><i className="fa fa-paper-plane"></i> Invite members</h4>
              </div>
              <div className="modal-body">
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
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-info pull-left" data-dismiss="modal">Send Invitations</button>
                <button type="button" className="btn btn-default" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}