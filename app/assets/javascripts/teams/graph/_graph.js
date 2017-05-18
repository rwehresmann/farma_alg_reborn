$(document).ready(function() {
  if (window.location.pathname ==
      Routes.graph_team_path($('#show-team').data('team-id'))) {
    $('li.active').removeClass('active');
    $('li:has(a[href="#graph"])').addClass('active');
  }
});
