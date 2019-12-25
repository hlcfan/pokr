let Retro

Retro = (function(){
  function Retro() {}

  Retro.prototype.new = function() {
    $(".schemes-type span.label").on("click", (ele) => {
      $(".schemes-type .label").removeClass("label-info").addClass('label-default')
      let $target = $(ele.target)
      $target.addClass("label-info")
      $("#retro_scheme_uid").val(ele.target.getAttribute("data-scheme"))
    })
  }

  return Retro
})()

$(document).on("ready", () => {
  $(".retros.new").ready(() => {
    const retros = new Retro
    return retros.new()
  })
})
