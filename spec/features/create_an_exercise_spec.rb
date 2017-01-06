require 'rails_helper'

describe "Create an exercise", type: :feature do
  let(:exercise) { build(:exercise) }
  before do
    login_as create(:user)
    visit new_exercise_url
  end

  context "whit valid attributes" do
    subject do
      fill_in "exercise_title", with: exercise.title
      fill_in "exercise_description", with: exercise.description
      click_on "Criar"
    end

    it "create the exercise" do
      expect{ subject }.to change(Exercise, :count).by(1)
      expect(page).to have_current_path(exercise_path(Exercise.first.id))
    end
  end

  context "whit invalid attributes" do
    subject do
      click_on "Criar"
    end

    it "doesn't create the exercise" do
      expect{ subject }.to change(Exercise, :count).by(0)
      expect(page).to have_selector("div.alert.alert-danger")
    end
  end
end
