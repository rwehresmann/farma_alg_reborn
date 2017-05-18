$(document).ready(function() {
  if (window.location.pathname ==
      Routes.rankings_team_path($('#show-team').data('team-id'))) {
    $('li.active').removeClass('active');
    $('li:has(a[href="#rankings"])').addClass('active');
  }
});
