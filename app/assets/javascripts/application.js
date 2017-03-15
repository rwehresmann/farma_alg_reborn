// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require turbolinks
//= require AdminLTE/bootstrap/js/bootstrap
//= require AdminLTE/dist/js/app
//= require AdminLTE/plugins/daterangepicker/moment.min
//= require AdminLTE/plugins/daterangepicker/daterangepicker
//= require AdminLTE/plugins/datatables/jquery.dataTables
//= require AdminLTE/plugins/datatables/dataTables.bootstrap.min
//= require simplemde/dist/simplemde.min
//= require ace-builds/src-min/ace
//= require ace-builds/src-min/theme-twilight
//= require ace-builds/src-min/mode-pascal
//= require vivagraphjs/dist/vivagraph
//= require_tree .


// If modal isn't present in the page, create it (even if 'create' flag is
// false), else create it (first excluding it from the page) only if 'create'
// flag is true.
// OBS: 'createModal', used inside 'showModal', must be created inside the
// view where 'showModal' is called, using the apropriate tag ids
// ('modal_name-container', 'modal_name-modal').
// OBS2: 'createModal' cannot be created here because it uses rails 'render'
// method (and in assets isn't alowed to use ruby embed code).
function showModal(modal_name, create = true) {
  var modal = $('#' + modal_name + '-container');

  if (modal.length) {
    if (create) {
      modal.remove();
      createModal(modal_name);
    }
  } else createModal(modal_name);

  $('#' + modal_name + '-modal').modal('show');
}
