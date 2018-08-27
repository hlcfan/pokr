# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


class Leaflets
  show: ->
    window.leafletVotes = JSON.parse($("#leafletVotes").val()) || {}

    roomId = $("#roomId").val()
    $(".leaflet .point-values .btn").on "click", ->
      $that = $(this)
      $that.parents(".point-values").find(".btn").removeClass("btn-info")
      $that.toggleClass("btn-info")
      ticketId = $that.parents(".point-values").data("ticket-id")
      point = $that.val()
      comment = $that.parents(".point-values").next().val()
      $("input[value=" + ticketId + "]").siblings(".leaflet__vote-point").val(point)
      $("input[value=" + ticketId + "]").siblings(".leaflet__vote-comment").val(comment)
      # leafletVotes[$that.parents(".point-values").data("ticket-id")] = { point: $that.val(), comment: comment }

    $(".finalize-link-col__finalize-link").on "click", ->
      $that = $(this)

      $.ajax(
        url: "/rooms/#{roomId}/leaflet_finalize_point"
        method: "POST"
        data: { voteId: $that.parents("tr").data("voteId") },
        cache: false
      ).done((data) ->
        $that.parents("table").find("tr .finalize-link-col__finalize-link").removeClass("hidden")
        $that.parents("table").find("tr .finalize-link-col__check-icon").addClass("hidden")
        $that.addClass("hidden")
        $that.prev().removeClass("hidden")
        return
      ).fail((xhr, status, err) ->
        console.error status, err.toString()
        return
      )


$(document).on "ready", ->
  $(".rooms.new .leaflet, .rooms.show .leaflet, .rooms.leaflet_view, .rooms.create, .rooms.update").ready ->
    leaflet = new Leaflets
    leaflet.show()
