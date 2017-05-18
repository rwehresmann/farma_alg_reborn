$(document).ready(function() {
  if (window.location.pathname ==
      Routes.exercises_team_path($('#show-team').data('team-id'))) {
    $('li.active').removeClass('active');
    $('li:has(a[href="#exercises-list"])').addClass('active');
  }
});

$(document).on('click', "#add-exercise", function() {
  showModal("exercises", false, createModal);
});
