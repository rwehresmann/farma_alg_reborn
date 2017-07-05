class Recommendations
  index: ->
    $(document).on 'click', "tr[data-link]", ->
      url = $(this).data("link")
      window.open(url, "_blank")

window.APP ?= {}
window.APP.Recommendations = Recommendations
