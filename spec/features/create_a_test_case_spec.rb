require 'rails_helper'

describe "Create a test case", type: :feature do
  let(:test_case) { build(:test_case) }
  before do
    login_as create(:user, :teacher)
    question = create(:question)
    visit new_question_test_case_url(question.id)
  end

  context "whit valid attributes" do
    subject do
      fill_in "test_case_title", with: test_case.title
      fill_in "test_case_description", with: test_case.description
      fill_in "test_case_output", with: test_case.output
      click_on "Criar"
    end

    it "create the test case" do
      expect{ subject }.to change(TestCase, :count).by(1)
      expect(page).to have_current_path(test_case_path(TestCase.first.id))
    end
  end

  context "whit invalid attributes" do
    subject do
      click_on "Criar"
    end

    it "doesn't create the test case" do
      expect{ subject }.to change(TestCase, :count).by(0)
      expect(page).to have_selector("div.alert.alert-danger")
    end
  end
end
