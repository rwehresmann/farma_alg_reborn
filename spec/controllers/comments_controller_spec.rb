require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "POST #create" do
    let(:user) { create(:user, :teacher) }
    let(:answer) { create(:answer) }

    subject { post :create, xhr: true, params: { answer_id: answer, comment: { content: "content" } }  }

    context "when logged-in" do
      before do
        sign_in user
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("comments/create") }
    end

    context "when logged-out" do
      before { subject }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user, :teacher) }
    let!(:comment) { create(:comment, user: user) }

    subject { put :update, xhr: true, params: { id: comment, comment: { content: "content" } }  }

    context "when logged-in" do
      before do
        sign_in user
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("comments/update") }
    end

    context "when logged-out" do
      before { subject }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user, :teacher) }
    let!(:comment) { create(:comment, user: user) }

    subject { delete :destroy, xhr: true, params: { id: comment }  }

    context "when logged-in" do
      before do
        sign_in user
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("comments/destroy") }
    end

    context "when logged-out" do
      before { subject }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
  end

end
