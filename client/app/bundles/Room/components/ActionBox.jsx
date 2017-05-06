import PropTypes from 'prop-types';
import React from 'react';
import ResultPanel from '../components/ResultPanel';
import EventEmitter from 'libs/eventEmitter';

export default class ActionBox extends React.Component {

  state = {
    buttonState: this.props.roomState
  }

  showResult = (e) => {
    this.setState({buttonState: 'open'});
    if (!Cookies.get('showTip')) {
      Cookies.set('showTip', true);
    }
    publishResult();
  }

  skipStory = () => {
    if (this.props.role === 'Moderator') {
      App.rooms.perform('set_story_point', {
        roomId: this.props.roomId,
        data: { point: 'null', story_id: this.props.storyId }
      });
    }
  }

  clearVotes = () => {
    if (this.props.role === 'Moderator') {
      App.rooms.perform('clear_votes', {
        roomId: this.props.roomId,
        data: { story_id: this.props.storyId }
      });
    }
  }

  resetActionBox = () => {
    this.setState({ buttonState: 'not-open' });
  }

  setToDrawBoard = () => {
    this.setState({ buttonState: 'draw' });
  }

  showBoard = () => {
    $('#board').html('');
    drawBoard();
  }

  resetTimer = () => {
    // if (!this.props.timerInterval) {
    //   return
    // }
    // let timer;

    // if (timer > 0) {
    //   clearInterval(POKER.timer);
    // }
    // $(".timer").show();
    // $(".timer .counter").text(POKER.timerInterval);
    // let tick = POKER.timerInterval;
    // const $icon = $(".timer .fa");

    // POKER.timer = setInterval(() => {
    //   if (tick <= 0) {
    //     if (!$icon.hasClass("warning")) {
    //       $(".timer .counter").text("Time up");
    //       $icon.attr("class", "fa warning").text("⚠️");
    //     }
    //     const $warning = $(".warning");
    //     if(!$warning.is(':animated')) {
    //       $warning.fadeToggle("fast");
    //     }
    //   } else {
    //     if (!$icon.hasClass("sandglass")) {
    //       $icon.attr("class", "fa sandglass").text("⌛").show();
    //     }
    //     tick -= 1;
    //     $(".timer .counter").text(tick);
    //   }
    // }, 1000);
  }

  disableTimer = () => {
    // $(".timer").remove();
  }

  componentDidMount = () => {
    EventEmitter.subscribe("resetActionBox", this.resetActionBox);
    // EventEmitter.subscribe("roomClosed", this.setToDrawBoard);
    // EventEmitter.subscribe("roomClosed", this.disableTimer);
    if (this.props.roomState !== "draw" && this.props.timerInterval > 0) {
      EventEmitter.subscribe("resetTimer", this.resetTimer);
      this.resetTimer();      
    }
    if (this.props.roomState === 'open') {
      showResultSection();
    }
  }

  render() {
    let onClickName;
    let buttonText;
    let buttonHtml;
    let secondButtonText;
    let secondOnClickName;
    let buttonCount = 1;

    if (this.props.role === 'Moderator') {
      if (this.state.buttonState === 'not-open') {
        onClickName = this.showResult;
        buttonText = "Flip";
      } else if (this.state.buttonState === 'open') {
        onClickName = this.skipStory;
        buttonText = "Skip it";
        secondOnClickName = this.clearVotes;
        secondButtonText = "Clear votes"
        buttonCount = 2;
      } else if (this.state.buttonState === 'draw') {
        onClickName = this.showBoard;
        buttonText = "Show board";
      }
    }
    buttonHtml = ((() => {
      if (onClickName && buttonText && buttonCount > 1) {
        return (
          <div className="btn-group btn-group-lg btn-group-justified" role="group">
            <a onClick={onClickName} className="btn btn-default btn-lg btn-info" href="javascript:;" role="button">
              {buttonText}
            </a>
            <a onClick={secondOnClickName} className="btn btn-default btn-lg btn-info" href="javascript:;" role="button">
              {secondButtonText}
            </a>
          </div>
        )
      } else if(onClickName && buttonText) {
        return (
          <div className="" role="group">
            <a onClick={onClickName} className="btn btn-default btn-lg btn-info btn-block" href="javascript:;" role="button">
              {buttonText}
            </a>
          </div>
        )
      }
    }))()

    const tip = ((() => {
      // already decided point
      if (Cookies.get('showTip') && !Cookies.get('adp') && this.props.role === 'Moderator') {
        Cookies.set('adp', true);
        return (
          <div className="container-fluid" style={{clear: 'both', width: '90%'}}>
            <div className="alert alert-success alert-dismissible" role="alert">
              <button type="button" className="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <strong>Tip!</strong> Click the bar below to decide the point.
            </div>
          </div>
        )
      }
    }))()

    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          Action
          <span className="timer pull-right" style={{display: 'none'}}>
            <i className="fa sandglass">⌛</i>
            &nbsp;
            <i className="counter">{this.props.timerInterval}</i>
          </span>
        </div>
        <div className="panel-body row">
          <div id="actionBox" className="row">
            {tip}
            <ResultPanel roomId={this.props.roomId} role={this.props.role} storyId={this.props.storyId} />
            <div className="openButton container-fluid">
              {buttonHtml}
            </div>
          </div>
        </div>
      </div>
    )
  }
}