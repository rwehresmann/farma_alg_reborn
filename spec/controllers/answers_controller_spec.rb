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

  describe "GET #show" do
    let(:answer) { create(:answer) }

    context "when logged-in" do
      before { sign_in create(:user, :teacher) }

      context "with an ajax request" do
        before { get :show, xhr: true, params: { id: answer } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq("text/javascript") }
        it { expect(response).to render_template(:show) }
        it { expect(assigns(:answer)).to_not be_nil }
      end

      context "when requesting a html" do
        before { get :show, params: { id: answer } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq("text/html") }
        it { expect(response).to render_template(:show) }
        it { expect(assigns(:similar_answers)).to_not be_nil }
      end
    end

# TODO: Should be implemented after defined answer permissions.
=begin
    context "when logged-out" do
      before { subject }

      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
=end
  end

  describe "GET #connections" do
    let(:answer) { create(:answer) }

    subject { get :connections, xhr: true, params: { id: answer } }

    context "when logged-in" do
      before do
        sign_in create(:user, :teacher)
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("application/json") }
      it { expect(assigns(:connections)).to_not be_nil }
    end

# TODO: Should be implemented after defined answer permissions.
=begin
    context "when logged-out" do
      before { subject }

      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
=end
  end

end
