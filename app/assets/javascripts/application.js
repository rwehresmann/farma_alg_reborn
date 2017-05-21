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
//= require js-routes
//= require coffee_routes
//= require jsdifflib/difflib
//= require jsdifflib/diffview
//= require_tree .

$(document).ready(function() {
  addControllerJS();
});
