class Teams
  index: ->
    $('#all-teams').click =>
      $('#my-teams').removeClass('active')
      $(this).addClass('active')

    $('#my-teams').click =>
      $('#all-teams').removeClass('active')
      $(this).addClass('active')

  rankings: ->
    this.nav_tabs_ajax_calls()

    window.history.pushState(
      '',
      '',
      CoffeeRoutes.path('rankings_team', { 'id': this.team_id() })
    )

    $('li.active').removeClass('active')
    $('li:has(a[href="#rankings"])').addClass('active')

  exercises: ->
    this.nav_tabs_ajax_calls()

    window.history.pushState(
      '',
      '',
      CoffeeRoutes.path('exercises_team', { 'id': this.team_id() })
    )

    $('li.active').removeClass('active')
    $('li:has(a[href="#exercises-list"])').addClass('active')

    $(document).on 'click', '#add-exercise', ->
      showModal("exercises", false, createModal);

    createModal("exercises");

  users: ->
    window.history.pushState(
      '',
      '',
      CoffeeRoutes.path('users_team', { 'id': this.team_id() })
    )

    $('li.active').removeClass('active')
    $('li:has(a[href="#enrolled-students"])').addClass('active')

  graph: ->
    window.history.pushState(
      '',
      '',
      CoffeeRoutes.path('graph_team', { 'id': this.team_id() })
    )

    $('li.active').removeClass('active')
    $('li:has(a[href="#graph"])').addClass('active')

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
       div = $(document.createElement('div'))
       div.attr('id', 'loading-modal')
       $('.modal-content').append(div)

  team_id: ->
    $('#show-team').data('team-id')

  nav_tabs_ajax_calls: ->
    $('a[href="#rankings"]').click =>
      $.ajax
        url: CoffeeRoutes.path('rankings_team', { 'id': this.team_id() }),
        type: 'GET',
        dataType: 'script'

    $('a[href="#exercises-list"]').click =>
      $.ajax
        url: CoffeeRoutes.path('exercises_team', { 'id': this.team_id() }),
        type: "GET",
        dataType: 'script'

    $('a[href="#enrolled-students"]').click =>
      $.ajax
        url: CoffeeRoutes.path('users_team', { 'id': this.team_id() }),
        type: "GET",
        dataType: 'script'

    $('a[href="#graph"]').click =>
      $.ajax
        url: CoffeeRoutes.path('graph_team', { 'id': this.team_id() }),
        type: "GET",
        dataType: 'script'

window.APP ?= {}
window.APP.Teams = Teams
