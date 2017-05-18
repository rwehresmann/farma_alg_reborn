$(document).ready(function() {
  if (window.location.pathname ==
      Routes.users_team_path($('#show-team').data('team-id'))) {
    $('li.active').removeClass('active');
    $('li:has(a[href="#enrolled-students"])').addClass('active');
  }
});
