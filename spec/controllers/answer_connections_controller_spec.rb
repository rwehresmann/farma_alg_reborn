require 'rails_helper'

RSpec.describe AnswerConnectionsController, type: :controller do
  describe "GET #show" do
    let(:answer_connection) { create(:answer_connection) }

    subject { get :show, xhr: true, params: { id: answer_connection } }

    context "when logged-in" do
      before do
        sign_in create(:user, :teacher)
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("answer_connections/show") }
      it { expect(assigns(:connection)).to_not be_nil }
    end

    context "when logged-out" do
      before { subject }

      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
  end

  describe "DELETE #destroy" do
    let(:answer_connection) { create(:answer_connection) }

    subject { delete :destroy, xhr: true, params: { id: answer_connection } }

    context "when logged-in" do
      before do
        sign_in create(:user, :teacher)
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("answer_connections/destroy") }
      it { expect(assigns(:connection)).to_not be_nil }
    end

    context "when logged-out" do
      before { subject }

      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
  end

end
