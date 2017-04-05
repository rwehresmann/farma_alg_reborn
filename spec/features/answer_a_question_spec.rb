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

  # TODO
  context "whit a wrong answer" do
  end
end
