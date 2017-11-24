import PropTypes from 'prop-types'
import React from 'react'
import css from './index.scss'

export default class Item extends React.Component {
  static propTypes = {
    roomId: PropTypes.string,
    itemIndex: PropTypes.number,
    email: PropTypes.string,
    emailsCount: PropTypes.number,
    onRemoveHandler: PropTypes.func,
    onChangeHandler: PropTypes.func
  }

  onRemove = () => {
    this.props.onRemoveHandler(this.props.itemIndex)
  }

  onChange = (event) => {
    let emailAddress = event.target.value
    this.props.onChangeHandler(this.props.itemIndex, emailAddress)
  }

  render() {
    return (
      <div className="row">
        <div className="col-xs-8">
          <label>Email address</label>
          <div className="row">
            <div className="col-xs-11">
              <input type="email"
                className="form-control"
                name="email"
                placeholder="Email"
                defaultValue={this.props.email}
                onBlur={this.onChange}
                />
            </div>
            {
              this.props.emailsCount > 1 &&
                <div className={`col-xs-1 ${css.invitation__remove}`}>
                  <a href="javascript:;" onClick={this.onRemove}><i className="fa fa-trash-o fa-3"></i></a>
                </div>
            }
          </div>
        </div>
      </div>
    )
  }
}