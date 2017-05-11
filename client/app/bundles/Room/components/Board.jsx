import PropTypes from 'prop-types';
import React from 'react';

export default class Board extends React.Component {
  rawMarkup = () => {
    const rawMarkup = marked(this.props.children.toString(), {sanitize: true});
    return { __html: rawMarkup };
  }

  loadStoryListFromServer = () => {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: data => {
        this.setState({data});
      },
      error: (xhr, status, err) => {
        console.error(this.props.url, status, err.toString());
      }
    });
  }

  state = {
    data: []
  }

  componentDidMount = () => {
    this.loadStoryListFromServer();
    $('#board .modal').modal({keyboard: false, backdrop: 'static'});
  }

  render() {
    const dataNodes = this.state.data.map(story => {
      const point = pointEmojis[story.point] || story.point;
      return (
        <tr key={story.id}>
          <td><a href={storyLinkHref(story.link)} target="_blank">{story.link}</a></td>
          <td>{point}</td>
        </tr>
      );
    });

    return (
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
              </table>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-default" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
    )
  }
}