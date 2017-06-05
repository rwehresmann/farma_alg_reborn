class Teams
  index: ->
    $('#all-teams').click =>
      $('#my-teams').removeClass('active')
      $(this).addClass('active')

    $('#my-teams').click =>
      $('#all-teams').removeClass('active')
      $(this).addClass('active')

  rankings: ->
    $('li.active').removeClass('active')
    $('#rankings-item').addClass('active')

  exercises: ->
    $('li.active').removeClass('active')
    $('#exercises-item').addClass('active')

    $(document).on 'click', '#add-exercise', ->
      showModal("exercises", false, createModal);

    createModal("exercises");

  users: ->
    $('li.active').removeClass('active')
    $('#users-item').addClass('active')

  graph: ->
    $('li.active').removeClass('active')
    $('#graph-item').addClass('active')

    initialize_graph();

    $('#pause-resume').click ->
      if $('#pause-resume i').attr('class') == "fa fa-pause"
        pause()
        $('#pause-resume i').attr('class', 'fa fa-play')
        $('#pause-resume i').attr('title', 'Resume graph animation')
      else
        resume()
        $('#pause-resume i').attr('class', 'fa fa-pause')
        $('#pause-resume i').attr('title', "Stop graph animation")


     $('#back-center').click ->
       reset()

     $('#remove-graph').click ->
       dispose()

     $(document).on 'click', '#add-nodes', ->
       showModal('search', false, createModal)

     $(document).on 'click', '#search-btn', ->
       $('#loading-modal').remove()
       div = $(document.createElement('div'))
       div.attr('id', 'loading-modal')
       $('.modal-content').append(div)

window.APP ?= {}
window.APP.Teams = Teams
