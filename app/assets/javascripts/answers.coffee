class Answers
  index: ->
    $(document).on "click", "tr[data-link]", ->
      url = $(this).data("link")
      window.open(url, "_blank")
  new: ->
    new_height = $('.content-wrapper').height() +
      $('#test-results').height() +
      $('#error_explanation').height() +
      500
    $('.content-wrapper').height(new_height)

    $("a").preventDefault

window.APP ?= {}
window.APP.Answers = Answers
