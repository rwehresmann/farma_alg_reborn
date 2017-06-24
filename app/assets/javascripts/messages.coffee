class Messages
  index: ->
    $('#messages-received').click =>
      $('#messages-sended').removeClass('active')
      $(this).addClass('active')

    $('#messages-sended').click =>
      $('#messages-received').removeClass('active')
      $(this).addClass('active')

window.APP ?= {}
window.APP.Messages = Messages
