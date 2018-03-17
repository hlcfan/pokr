$(document).on 'ready', ->
  window.storyRooms = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/typeahead.json?query=%QUERY',
      wildcard: '%QUERY'
  )

  $('#typeahead-input').typeahead { minLength: 3 },
    name: 'story-rooms'
    limit: 10
    source: storyRooms
    templates: {
      empty: [
        '<div class="empty-message">',
          '&nbsp;&nbsp; Nah 😐',
        '</div>'
      ].join('\n'),
      suggestion: (data) ->
        return '<a href="' + data.link + '">' + '<i class="fa fa-' + data.type + '">' + '</i>' + '<span class="title">' + data.title + '</span>' + '</i>' + '<sub>' + data.sub_title + '</sub>' + '<i class="label label-info indicator">' + data.indicator + '</i>' + '</a>'
    }

