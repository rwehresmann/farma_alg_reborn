class Recommendations
  index: ->
    $("tr[data-link]").click ->
      url = $(this).data("link")
      window.open(url, "_blank")

window.APP ?= {}
window.APP.Recommendations = Recommendations
