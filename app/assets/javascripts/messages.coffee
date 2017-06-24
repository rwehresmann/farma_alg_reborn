class Messages
  index: ->
    $("#answers-table").DataTable
      "paging": false,
      "lengthChange": true,
      "searching": false,
      "retrieve": true,
      "ordering": true,
      "info": false,
      "autoWidth": true

    $('#messages-received').click =>
      $('#messages-sended').removeClass('active')
      $(this).addClass('active')

    $('#messages-sended').click =>
      $('#messages-received').removeClass('active')
      $(this).addClass('active')

    $(document).on 'click', "tr[data-link]", ->
      url = $(this).data("link")
      window.open(url, "_blank")

window.APP ?= {}
window.APP.Messages = Messages
