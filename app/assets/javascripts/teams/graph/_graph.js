$(document).ready(function() {
  if (window.location.pathname ==
      Routes.graph_team_path($('#show-team').data('team-id'))) {
    $('li.active').removeClass('active');
    $('li:has(a[href="#graph"])').addClass('active');

    initialize_graph();

    $('#pause-resume').click(function() {
       if ($('#pause-resume i').attr('class') == "fa fa-pause") {
         pause();
         $('#pause-resume i').attr('class', 'fa fa-play');
         $('#pause-resume i').attr('title', 'Resume graph animation');
       }
       else {
         resume();
         $('#pause-resume i').attr('class', 'fa fa-pause');
         $('#pause-resume i').attr('title', "Stop graph animation");
       }
     });

     $('#back-center').click(function() {
       reset();
     });

     $('#remove-graph').click(function() {
       dispose();
     });
  }

  $(document).on('click', "#add-nodes", function() {
    showModal("search", false, createModal);
  });
});
