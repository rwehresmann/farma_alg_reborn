module Helpers::AceEditorHelper
  # Credits to Eliot Sykes (https://www.eliotsykes.com/testing-ace-editor)
  def fill_in_editor_field(text)
    find_ace_editor_field.set text
  end

  # Ace uses textarea.ace_text-input as
  # its input stream.
  def find_ace_editor_field
    input_field_locator = ".ace_text-input"
    is_input_field_visible = false
    find(input_field_locator, visible: is_input_field_visible)
  end

  # Ace uses div.ace_content as its
  # output stream to display the code
  # entered in the textarea.
  def have_editor_display(options)
    editor_display_locator = ".ace_content"
    have_css(editor_display_locator, options)
  end
end
