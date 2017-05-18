$(document).ready(function() {
  if ($('#show-team').length > 0) {
    $('a[href="#rankings"]').click(function() {
      $.ajax({
         type: "GET",
         url: Routes.rankings_team_path($('#show-team').data('team-id')),
         dataType: 'script'
       });
    });

    $('a[href="#exercises-list"]').click(function() {
      $.ajax({
         type: "GET",
         url: Routes.exercises_team_path($('#show-team').data('team-id')),
         dataType: 'script'
       });
    });

    $('a[href="#enrolled-students"]').click(function() {
      $.ajax({
         type: "GET",
         url: Routes.users_team_path($('#show-team').data('team-id')),
         dataType: 'script'
       });
    });

    $('a[href="#graph"]').click(function() {
      $.ajax({
         type: "GET",
         url: Routes.graph_team_path($('#show-team').data('team-id')),
         dataType: 'script'
       });
    });
  }
});
