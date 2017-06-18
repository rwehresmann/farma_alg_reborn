require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe "GET #index" do
    context "when logged in" do
      context "with and html request" do
        it "renders index page" do
          sign_in create(:user)
          get :index

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "answers/index"
          )
        end
      end

      context "with an ajax request" do
        it "renders index page" do
          sign_in create(:user)
          get :index, xhr: true

          common_expectations(
            http_status: :ok,
            content_type: "text/javascript",
            template: "answers/index"
          )
        end
      end
    end

    context "when logged out" do
      context "with and html request" do
        it "renders index page" do
          get :index

          common_expectations(
            http_status: 302,
            content_type: "text/html"
          )
        end
      end

      context "with an ajax request" do
        it "renders index page" do
          get :index, xhr: true

          common_expectations(
            http_status: 401,
            content_type: "text/javascript"
          )
        end
      end
    end
  end

  describe "GET #new" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:team) { create(:team) }
    subject { get :new, params: { id: question, team_id: team } }

    context "when logged-in" do
      before { sign_in user }

      it { expect(subject).to have_http_status(:ok) }

      it { expect(subject.content_type).to eq("text/html") }

      it { expect(subject).to render_template("answers/new") }

      it "sets the instance variables" do
        subject
        expect(assigns(:answer)).to_not be_nil
        expect(assigns(:team)).to_not be_nil
      end

      context "when user already have correct answered the question" do
        before do
          create(:answer, :correct, question: question, team: team, user: user )
          subject
        end

        it { expect(flash[:info]).to_not be_nil }
      end
    end

    context "when not logged-in" do
      before { subject }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end

  describe "GET #show" do
    let(:answer) { create(:answer) }

    subject(:ajax_request) { get :show, xhr: true, params: { id: answer } }
    subject(:html_request) { get :show, params: { id: answer }  }

    context "when logged-in" do
      before { sign_in create(:user, :teacher) }

      context "with an ajax request" do
        before { ajax_request }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq("text/javascript") }
        it { expect(response).to render_template(:show) }
        it { expect(assigns(:answer)).to_not be_nil }
      end

      context "when requesting a html" do
        before { html_request }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.content_type).to eq("text/html") }
        it { expect(response).to render_template(:show) }
        it { expect(assigns(:similar_answers)).to_not be_nil }
      end
    end

    context "when logged-out" do
      before { html_request }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end

  describe "GET #connections" do
    let(:answer) { create(:answer) }

    subject { get :connections, xhr: true, params: { id: answer, type: "with" } }

    context "when logged-in" do
      before do
        sign_in create(:user, :teacher)
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("application/json") }
      it { expect(assigns(:connections)).to_not be_nil }
    end

    context "when logged-out" do
      before { subject }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe "POST #create" do
    let(:team) { create(:team) }
    let(:question) { create(:question) }

    subject do
      post :create, xhr: true, params: { id: question,
           answer: attributes_for(:answer).merge(team_id: team.id) }
    end

    context "when logged-in" do
      before do
        user = create(:user)
        team.enroll(user)
        sign_in user
      end

      it { expect(subject).to have_http_status(:ok) }

      it { expect(subject.content_type).to eq("text/javascript") }

      it { expect(subject).to render_template("shared/test_answer") }

      it "sets the instance variables" do
        subject
        expect(assigns(:answer)).to_not be_nil
        expect(assigns(:question)).to_not be_nil
        expect(assigns(:results)).to_not be_nil
      end

      it { expect { subject }.to change(Answer, :count).by(1) }
    end

    context "when logged-out" do
      before { subject }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  def common_expectations(args = {})
    expect(response).to have_http_status args[:http_status] if args[:http_status]
    expect(response.content_type).to eq args[:content_type] if args[:content_type]
    expect(response).to render_template args[:template] if args[:template]
    expect(response).to redirect_to args[:redirect] if args[:redirect]
  end
end
