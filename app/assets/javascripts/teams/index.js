$(document).ready(function() {
  $('#all-teams').click(function() {
    $('#my-teams').removeClass('active');
    $(this).addClass('active');
  });

  $('#my-teams').click(function() {
    $('#all-teams').removeClass('active');
    $(this).addClass('active');
  });
});
