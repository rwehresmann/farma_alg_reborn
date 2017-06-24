class Dashboard
  home: ->
    $("#teams-answer-table").DataTable
      "paging": false,
      "lengthChange": true,
      "searching": false,
      "retrieve": true,
      "ordering": true,
      "info": false,
      "autoWidth": true

    $("#user-answers-table").DataTable
      "paging": false,
      "lengthChange": true,
      "searching": false,
      "retrieve": true,
      "ordering": true,
      "info": false,
      "autoWidth": true

    $(document).on 'click', "tr[data-link]", ->
      url = $(this).data("link")
      window.open(url, "_blank")

window.APP ?= {}
window.APP.Dashboard = Dashboard
