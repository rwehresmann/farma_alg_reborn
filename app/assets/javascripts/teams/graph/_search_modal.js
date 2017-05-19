$(document).ready(function() {
  $(document).on('click', "#search-btn", function() {
    var div = $(document.createElement('div'))
    div.attr('id', 'loading-modal');
    $('.modal-content').append(div);
  });
});
