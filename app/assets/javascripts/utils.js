// If modal isn't present in the page, create it (even if 'create' flag is
// false), else create it (first excluding it from the page) only if 'create'
// flag is true.
// OBS: 'createModal', used inside 'showModal', must be created inside the
// view where 'showModal' is called, using the apropriate tag ids
// ('modal_name-container', 'modal_name-modal').
// OBS2: 'createModal' cannot be created here because it uses rails 'render'
// method (and in assets isn't alowed to use ruby embed code).

function showModal(modalName, recreate, createModalFunc) {
  var modal = $('#' + modalName + '-container');

  if (modal.length) {
    if (recreate) {
      modal.remove();
      // When modal container is removed, bootstrap will not be able to find a
      // reference to close it, so modal-backdrop must be forced to be removed.
      $('.modal-backdrop').remove();
      createModalFunc(modalName);
    }
  } else createModalFunc(modalName);

  $('#' + modalName + '-modal').modal('show');
}

function addControllerJS() {
  controller = $('body').data('controller');
  action = $('body').data('action');

  if (window.APP[controller]) {
    klass = new window.APP[controller];
    if (klass[action]) klass[action]();
  }
}
