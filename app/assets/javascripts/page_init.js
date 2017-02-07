var POKER = window['POKER'] = {};

$(document).on('turbolinks:load', function(event) {
  POKER.currentUser = { name: $(".dropdown-toggle").text().trim() };
});