import PropTypes from 'prop-types'
import React from 'react'
import BarColors from 'libs/barColors'
import EventEmitter from 'libs/eventEmitter'
import Helper from 'libs/helper'

export default class Story extends React.Component {

  state = {}

  revote = (e) => {
    const revoteStoryId = $(e.target).parents("li").data("id");
    if (this.props.role === 'Moderator') {
      App.rooms.perform('revote', {
        roomId: this.props.roomId,
        data: { story_id: revoteStoryId }
      });
    }
  }

  ticketSynked = (data) => {
    // alert(`${data.link}===${this.props.link}`)
    // alert(Helper.jiraTicketUrlForApi(data.link))
    if(Helper.jiraTicketUrlForClient(data.link) === this.props.link) {
      this.setState({synked: true})
      console.log(`${this.props.link} is updated ===`)
    }
  }

  componentDidMount() {
    EventEmitter.subscribe("ticketSynked", this.ticketSynked)
  }

  render() {
    const that = this;
    let revoteIcon;
    let liElementClass;
    let aa = Helper.jiraTicketUrlForApi(this.props.link)
    console.log(`A: ${aa}`)
    revoteIcon = (() => {
      if (this.props.role === 'Moderator' && that.props.tab === "groomed" && this.props.roomState !== "draw") {
        return(
          <a href="javascript:;" className="revote" onClick={that.revote}>
            <i className="fa fa-refresh"></i>
          </a>
        )
      }
    })()

    liElementClass = (() => {
      if (that.props.tab === "groomed") {
        return("story story__groomed");
      } else {
        return("story story__ungroomed");
      }
    })()

    const storyTitle = (() => {
      if (that.props.link.trim().startsWith('http')) {
        return(
          <a href={storyLinkHref(that.props.link)} className="storyLink" rel="noreferrer" target="_blank">
          {this.props.link}
          </a>
        )
      } else {
        return (
          <span className="storyLink">{this.props.link}</span>
        )
      }
    })()

    const synkedStatus = (() => {
      if(this.state.synked) {
        return(
          <a href="javascript:;" className="synk pull-right"><i className="fa fa-check"></i></a>
        )
      }
    })()

    return (
      <li className={liElementClass} id={`story-${this.props.id}`} data-id={this.props.id}>
        {storyTitle}
        <span className="label label-info story--voted-point">{BarColors.emoji(this.props.point) || this.props.point}</span>
        {revoteIcon}
        {synkedStatus}
        {this.props.syncStatus}
        <p className="story-desc">
          {this.props.desc}
        </p>
      </li>
    )
  }
}
