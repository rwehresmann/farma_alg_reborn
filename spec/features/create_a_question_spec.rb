require 'rails_helper'

describe "Create a quetsion", type: :feature do
  let(:question) { build(:question) }

  before do
    login_as create(:user, :teacher)
    exercise = create(:exercise)
    visit new_exercise_question_url(exercise.id)
  end

  context "whit valid attributes" do
    subject do
      fill_in "question_registered_score", with: question.registered_score
      fill_in "question_title", with: question.title
      fill_in "question_description", with: question.description
      click_on "Criar"
    end

    it "create the question" do
      expect{ subject }.to change(Question, :count).by(1)
      expect(page).to have_current_path(question_path(Question.first.id))
    end
  end

  context "whit invalid attributes" do
    subject do
      click_on "Criar"
    end

    it "doesn't create the exercise" do
      expect{ subject }.to change(Question, :count).by(0)
      expect(page).to have_selector("div.alert.alert-danger")
    end
  end
end
