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
      window.location = $(this).data("link")

window.APP ?= {}
window.APP.Answers = Answers
