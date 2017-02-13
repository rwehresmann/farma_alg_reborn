require 'rails_helper'

describe "Answer a question", type: :feature, js: true do
  subject(:visit_page) do
    login_as create(:user)

    exercise = create(:exercise)
    question = create_a_question_to_exercise(exercise)
    create(:test_case, :hello_world, question: question)

    visit new_answer_path(question)
  end

  subject(:submit_answer) do
    visit_page
    fill_in_editor_field content
    find('[name=commit]').click
  end

  it "shows the answer" do
    visit_page
    content = "puts 'Hello, world!'"
    fill_in_editor_field content
    expect(page).to have_editor_display text: content
  end


  context "with a right answer" do
    let(:content) { IO.read("spec/support/files/hello_world.pas") }

    it "informs that the answer is right" do
      submit_answer
      expect(page).to have_css(".alert.alert-success")
    end
  end

  context "whit a wrong answer" do
    let(:content) { IO.read("spec/support/files/hello_world_compilation_error.pas") }

    it "informs that the answer is wrong" do
      submit_answer
      expect(page).to have_css(".alert.alert-danger")
    end
  end

    private

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
