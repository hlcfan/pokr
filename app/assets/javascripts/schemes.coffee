# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class Schemes
  init: ->
    $('.scheme-form--add').on 'click', ->
        $('select').tagsinput 'add', $('.scheme-form--input').val()
        return

    $('.scheme-form .scheme-form--input').on 'keyup', (e) ->
      event.preventDefault()
      keyCode = e.keyCode or e.which or e.charCode
      if event.keyCode == 13
        $('select').tagsinput 'add', $('.scheme-form--input').val()
      return

    $('.scheme-form select#scheme_points').tagsinput
      maxTags: 50
      maxChars: 12
      trimValue: true

    $('select').on 'itemAdded', ->
      $('.scheme-form--input').val ''
      return

    $('.scheme-form').on 'keypress', (e) ->
      keyCode = e.keyCode or e.which or e.charCode
      if 13 == keyCode
        return false
      return

$(document).on "ready", ->
  $(".schemes.new, .schemes.edit, .schemes.create, .schemes.update").ready ->
    schemes = new Schemes
    schemes.init()

