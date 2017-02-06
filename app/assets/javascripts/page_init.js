$(document).on('turbolinks:load', function(event) {
  var POKER = window['POKER'] = function(){};
  POKER.currentUser = { name: $(".dropdown-toggle").text().trim() };
  POKER.page = {
    controller_name: $("body").data("controller-name"),
    action_name: $("body").data("action-name")
  }
});