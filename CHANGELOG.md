# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.2.15] - 2017-03-09
### Changed
- Intact room form [#89](https://github.com/hlcfan/pokr/pull/89)

## [0.2.14] - 2017-03-04
### Changed
- Redo footer

## [0.2.13] - 2017-03-02
### Changed
- Cleaner result panel

## [0.2.12] - 2017-02-22
### Added
- Allow moderator to edit/close a room
- Reduce height of status bar to leave more space for content area

## [0.2.11] - 2017-02-10
### Changed
- Correct Turbolinks usage
- Reduce home page size(remove unused js files)
- Fix room status change(to closed) when go back/forward across pages
- Open room in current tab instead new tab

## [0.2.10] - 2017-01-19
### Changed
- Larger size of avatar
- Append 👑 for moderator instead of black circle
- Show story link if it's a story
- Show ongoing indicator to help tell which story is ongoing

## [0.2.9] - 2017-01-17
### Changed
- Fix current story id when re-vote story
- Fix user point(people list) not refresh issue
- Fix landing page sign up form 500 error

## [0.2.8] - 2017-01-16
### Added
- Display default avatar based on user name
- Allow user to upload avatar

## [0.2.7] - 2016-12-15
### Changed
- New home page, new look
- Rename Pokr to Pokrex

## [0.2.6] - 2016-12-10
### Added
- Dashboard now looks like a dashboard
  + Stats: Stories groomed, Time spent, Average per story
  + History: show a line chart of grooming history
  + Shrink rooms width
  + Add recently groomed stories
  + Add skip rate in stats

### Changed
- Expand width of dashboard

## [0.2.5] - 2016-11-30
### Added
- Can now switch groomed and un-groomed stories via tabs.
- Allow moderator to re-vote a story.

## [0.2.4] - 2016-10-11
### Changed
- Newly added egg timer is just fuckin ugly, replace icons with emojis,
  anyway the user experience of this is still shitty.

## [0.2.3] - 2016-10-09
### Added
- Add egg timer to ensure that discussion is structured

## [0.2.2] - 2016-09-10
### Changed
- Widen and enlarge room status
- Change 开 to Flip on the action button
- Change the sort to created date DESC of room list in dashboard page

### Added
- User can directly sign up on home page without redirecting to sign up page
  by opening a modal

## [0.2.1] - 2016-09-09
### Changed
- Support Emoji for some of the points, like coffee, question
- Change color scheme a bit, switch most green(success) to light blue(info)
- Colorize point bar from dark to light, as larger point to smaller one

### Added
- Feedback box - looking forward to more feedbacks!

## [0.2.0] - 2016-08-30
### Changed
- Switch most of communications from HTTP to WS
- Limit user name length to 20
- Rails 5.0.0 -> 5.0.0.1

## [0.1.2] - 2016-08-25
### Changed
- Reduce a few SQL queries
- Update react-rails to 1.8.2(react 15.3.0)

## [0.1.1] - 2016-08-07
### Changed
- Owner -> Moderator, to be more professional.

### Added
- Refresh people list when new user joins

## [0.1.0] - 2016-08-06
### Added
- This CHANGELOG file to hopefully serve as an evolving of Pokr.