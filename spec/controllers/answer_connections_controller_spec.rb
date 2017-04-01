require 'rails_helper'

RSpec.describe AnswerConnectionsController, type: :controller do
  describe "GET #show" do
    let(:answer_connection) { create(:answer_connection) }
    subject(:html_request) { get :show, params: { id: answer_connection } }
    subject(:ajax_request) { get :show, xhr: true, params: { id: answer_connection,
                                                             link_html_id: "id" } }

    context "when logged-in" do
      before { sign_in create(:user, :teacher) }

      context "with an ajax request" do
        before { ajax_request }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq("text/javascript") }
        it { expect(response).to render_template("answer_connections/show") }
        it { expect(assigns(:connection)).to_not be_nil }
        it { expect(assigns(:link_html_id)).to_not be_nil }
      end

      context "with a html request" do
        before { html_request }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq("text/html") }
        it { expect(response).to render_template("answer_connections/show") }
        it { expect(assigns(:connection)).to_not be_nil }
      end
    end

    context "when logged-out" do
      context "with an ajax request" do
        before { ajax_request }

        it { expect(flash[:warning]).to_not be_nil }
        it { expect(response).to render_template("shared/unauthorized") }
      end

      context "with a html request" do
        before { html_request }

        it { expect(response).to redirect_to(root_url) }
        it { expect(flash[:warning]).to_not be_nil }
      end
    end
  end

  describe "DELETE #destroy" do
    let(:answer_connection) { create(:answer_connection) }

    subject(:ajax_request) { delete :destroy, xhr: true, params: { id: answer_connection } }
    subject(:html_request) { delete :destroy, params: { id: answer_connection } }

    context "when logged-in" do
      before { sign_in create(:user, :teacher) }

      context "with an ajax request" do
        before { ajax_request }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq("text/javascript") }
        it { expect(response).to render_template("answer_connections/destroy") }
        it { expect(AnswerConnection.count).to eq(0) }
      end

      context "with an html request" do
        let(:url_answer) { answer_url(create(:answer)) }

        before do
          session[:previous_answer_url] = url_answer
          html_request
        end

        it { expect(response).to have_http_status(302) }
        it { expect(response.content_type).to eq("text/html") }
        it { expect(response).to redirect_to(url_answer) }
      end
    end

    context "when logged-out" do
      context "with an ajax request" do
        before { ajax_request }

        it { expect(flash[:warning]).to_not be_nil }
        it { expect(response).to render_template("shared/unauthorized") }
      end

      context "with a html request" do
        before { html_request }

        it { expect(flash[:warning]).to_not be_nil }
        it { expect(response).to redirect_to(root_url) }
      end
    end
  end

end
