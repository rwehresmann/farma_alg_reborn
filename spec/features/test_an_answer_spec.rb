require 'rails_helper'

describe "Test an answer", type: :feature, js: true do
  let(:user) { create(:user, :teacher) }
  let(:exercise) { create(:exercise, user: user) }
  let(:question) { create(:question, exercise: exercise) }
  let!(:test_case) { create(:test_case, output: "Hello, world.\n", question: question) }

  subject(:submit_answer) { click_on "Submeter resposta" }

  before do
    login_as user
    visit question_path(question)
    click_on "Testar solução"
  end

  context "when no anwer is given" do
    it "displays an alert div" do
      user = create(:user, :teacher)
      exercise = create(:exercise, user: user)
      question = create(:question, exercise: exercise)

      login_as user
      visit question_path(question)
      click_on "Testar solução"
      click_on "Submeter resposta"

      expect(page).to have_selector("div.alert.alert-danger")
    end
  end

  context "when the answer is right" do
    it "informs tat the answer is right" do
      user = create(:user, :teacher)
      exercise = create(:exercise, user: user)
      question = create(:question, exercise: exercise)
      create(:test_case, output: "Hello, world.\n", question: question)

      login_as user
      visit question_path(question)
      click_on "Testar solução"
      fill_in_editor_field(IO.read("spec/support/files/hello_world.pas"))
      click_on "Submeter resposta"

      expect(page).to have_content("Resposta correta")
      expect(page).to have_selector('#test-results div.alert.alert-success')
    end
  end

  context "when answer is wrong" do
    it "informs tat the answer is right" do
      user = create(:user, :teacher)
      exercise = create(:exercise, user: user)
      question = create(:question, exercise: exercise)
      create(:test_case, output: "Hello, world.\n", question: question)

      login_as user
      visit question_path(question)
      click_on "Testar solução"
      fill_in_editor_field("This is a wrong answer")
      click_on "Submeter resposta"

      expect(page).to have_content("Resposta incorreta")
      expect(page).to have_selector('#test-results div.alert.alert-danger')
    end
  end
end
