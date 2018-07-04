import PropTypes from 'prop-types'
import React from 'react'
import BarColors from 'libs/barColors'
import EventEmitter from 'libs/eventEmitter'

export default class Board extends React.Component {
  loadStoryListFromServer = () => {
    $.ajax({
      url: `/rooms/${this.props.roomId}/draw_board.json`,
      dataType: 'json',
      cache: false,
      success: data => {
        this.setState({ data })
        $('#board .modal').modal({keyboard: false, backdrop: 'static'})
      },
      error: (xhr, status, err) => {
        console.error(this.props.url, status, err.toString())
      }
    });
  }

  state = {
    data: []
  }

  componentDidMount = () => {
    this.loadStoryListFromServer();
    EventEmitter.subscribe("showBoard", () => {
      this.setState({ data: [] })
      this.loadStoryListFromServer()
    })
  }

  handleSync = () => {
    $("#board .modal").modal("hide")
    $("#synk-credential .modal").modal({keyboard: false, backdrop: "static"})
  }

  render() {
    let totalPoints = 0;
    const dataNodes = this.state.data.map(story => {
      if(!isNaN(story.point)) {
        totalPoints += Number(story.point)
      }
      const point = BarColors.emoji(story.point) || story.point;
      return (
        <tr key={story.id}>
          <td><a href={storyLinkHref(story.link)} target="_blank">{story.link}</a></td>
          <td>{point}</td>
        </tr>
      )
    })

    return (
      <div id="board">
        <div className="modal fade" tabIndex="-1" role="dialog">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title">C'est la vie</h4>
              </div>
              <div className="modal-body">
                <table className="table table-bordered">
                  <tbody>
                    <tr><th>Story</th><th>Point</th></tr>
                    {dataNodes}
                  </tbody>
                  {totalPoints > 0 &&
                    <tfoot>
                      <tr>
                        <td>Total</td>
                        <td>{totalPoints}</td>
                      </tr>
                    </tfoot>
                  }
                </table>
              </div>
              <div className="modal-footer">
                <a href={`/rooms/${this.props.roomId}/summary`} target="_blank" className="pull-left">View summary</a>
                <a href={`/rooms/${this.props.roomId}.xlsx`} target="_blank" className="pull-left" style={{marginLeft: 10 + 'px'}}>Download report</a>
                {
                  this.props.role === "Moderator" &&
                  <a className="pull-left" href="javascript:;" style={{marginLeft: 10+'px'}} onClick={this.handleSync}>Sync to Jira</a>
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
