require 'rails_helper'

describe "Test an answer", type: :feature, js: true do
  let(:user) { create(:user, :teacher) }
  let(:exercise) { create(:exercise, user: user) }
  let!(:question) { create(:question, exercise: exercise) }

  subject(:submit_answer) { click_on "Submeter resposta" }

  before do
    login_as user
    visit question_path(question)
    click_on "Testar solução"
  end

  context "when no anwer is given" do
    before { submit_answer }

    it { expect(page).to have_selector("div.alert.alert-danger") }
  end

  context "when a source code with errors is submited" do
    before do
      fill_in_editor_field("this doesn't compile")
      submit_answer
    end

    it { expect(page).to have_content("Erro de compilação") }
  end

  context "when a source code without errors is submited" do
    before do
      fill_in_editor_field(source_code)
      submit_answer
    end

    context "when answer is rigtht" do
      let(:source_code) { IO.read("spec/support/files/hello_world.pas") }

      before { create(:test_case, question: question, output: "Hello, world.\n") }

      it "informs that the answer is right and show test cases results" do
        expect(page).to have_content("Resposta correta")
        expect(page).to have_selector('#test-results div.alert', count: 1)
      end
    end

    context "when answer is wrong" do
      let(:source_code) { IO.read("spec/support/files/hello_world.pas") }

      before { create(:test_case, question: question, output: "output") }

      it "informs that the answer is right and show test cases results" do
        expect(page).to have_content("Resposta incorreta")
        expect(page).to have_selector('#test-results div.alert', count: 1)
      end
    end
  end
end
