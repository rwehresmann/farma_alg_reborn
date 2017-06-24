class Answers
  index: ->
    $("#answers-table").DataTable
      "paging": false,
      "lengthChange": true,
      "searching": false,
      "retrieve": true,
      "ordering": true,
      "info": false,
      "autoWidth": true

    $("tr[data-link]").click ->
      url = $(this).data("link")
      window.open(url, "_blank")

window.APP ?= {}
window.APP.Answers = Answers
