/*
  Create and customize ace editor.
  Please note, ace editor need to have a fixed height value (px), and that can
  mess up layout details related to the height of the elements, being necessary
  make some adjustments manually.
*/

var editor = ace.edit("editor_div");
editor.setTheme("ace/theme/twilight");
editor.getSession().setMode("ace/mode/pascal");
