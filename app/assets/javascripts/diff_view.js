/*
  - baseText = text wich one another text should be compared;
  - newText = text to be compared;
  - baseTextName = baseText label;
  - newTextName = newText label;
  - tagId = id of the tag where the diff view should be appended.
*/
function diffView(baseText, newText, baseTextName, newTextName, tagId) {
  baseText = difflib.stringAsLines(baseText);
  newText = difflib.stringAsLines(newText);

  // create a SequenceMatcher instance that diffs the two sets of lines
  var sm = new difflib.SequenceMatcher(baseText, newText);

  // get the opcodes from the SequenceMatcher instance
  // opcodes is a list of 3-tuples describing what changes should be made to the base text
  // in order to yield the new text
  var opcodes = sm.get_opcodes();
  var diffoutputdiv = document.createElement("div");

  while (diffoutputdiv.firstChild) diffoutputdiv.removeChild(diffoutputdiv.firstChild);
  var contextSize = $("contextSize").value;
  contextSize = contextSize ? contextSize : null;

  // build the diff view and add it to the current DOM
  diffoutputdiv.appendChild(diffview.buildView({
      baseTextLines: baseText,
      newTextLines: newText,
      opcodes: opcodes,
      // set the display titles for each resource
      baseTextName: baseTextName,
      newTextName: newTextName,
      contextSize: contextSize,
      viewType: $("inline").checked ? 1 : 0
  }));

  $("#" + tagId).append(diffoutputdiv);
}
