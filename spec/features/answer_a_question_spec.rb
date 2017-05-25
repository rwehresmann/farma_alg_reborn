require 'rails_helper'

describe "Answer a question", type: :feature, js: true do
  subject(:visit_page) do
    login_as create(:user)

    exercise = create(:exercise)
    question = create(:question, exercise: exercise)
    create(:test_case, :hello_world, question: question)
    team = create(:team, exercises: [exercise])

    visit new_answer_question_path(question, team)
  end

  subject(:submit_answer) do
    visit_page
    fill_in_editor_field content
    find('[name=commit]').click
  end

  context "with a right answer" do
    let(:content) { IO.read("spec/support/files/hello_world.pas") }

    before { submit_answer }

    it "informs that the answer is right" do
      expect(page).to have_selector("span", text: "Resposta correta")
    end

    it "shows the test case results" do
      expect(page).to have_selector('#test-results .alert.alert-success')
    end
  end

  context "whit a wrong answer" do
    let(:content) { "puts 'Hello world'" }

    before { submit_answer }

    it "informs that the answer is wrong and doesn't clean the editor display" do
      expect(page).to have_selector("span", text: "Resposta incorreta")
      expect(page).to have_editor_display text: content
    end

    it "shows the test case results" do
      expect(page).to have_selector('#test-results .alert.alert-danger')
    end
  end
end
