require 'rails_helper'

describe "Post a comment", js: true do
  let(:teacher) { create(:user, :teacher) }
  let!(:answer) { create(:answer) }

  before do
    login_as teacher
    visit answer_path(answer)
    fill_in "comment_content", with: "comment"
    find('[name=commit]').click
  end

  xit "add the comment to the page" do
    expect(page).to have_selector("li.time-label span", count: 1)
    expect(page).to have_selector("div.timeline-item", count: 1)
  end
end
