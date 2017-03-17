require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe "GET #new" do
    let(:question) { create(:question) }
    subject { get :new, params: { id: question } }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders new view" do
        expect(response).to render_template(:new)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
