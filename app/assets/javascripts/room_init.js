$(document).on('turbolinks:load', function(event) {
  var POKER = window['POKER'] = function(){};
  POKER.currentUser = { name: $(".dropdown-toggle").text().trim() };
});