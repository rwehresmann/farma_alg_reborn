require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe "GET #index" do
    subject { get :index }

    context "when logged-in" do
      before do
        sign_in create(:user, :teacher)
        subject
      end

      it "renders index view" do
        expect(response).to render_template(:index)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "GET #new" do
    subject { get :new }

    context "when logged-in" do
      before do
        sign_in create(:user, :teacher)
        subject
      end

      it "renders new view" do
        expect(response).to render_template(:new)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST #create" do
    subject(:post_with_valid_attributes) { post :create,
             params: { team: attributes_for(:team) } }

    context "when logged-in -->" do
      before { sign_in create(:user, :teacher) }

      context "whit valid attributes" do
        it "creates a new object" do
          expect{ post_with_valid_attributes }.to change(Team, :count).by(1)
        end
      end

      context "whit invalid attributes" do
        subject(:post_with_invalid_attributes) { post :create,
                params: { team: attributes_for(:team, name: nil) } }

        it "does not save the new object" do
          expect{ post_with_invalid_attributes }.to_not change(Team, :count)
        end
      end
    end

    context "when not logged-in" do
      before { post_with_valid_attributes }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:team) { create(:team) }
    subject { delete :destroy, params: { id: team } }

    context "when logged-in" do
      before do
        user = create(:user, :teacher)
        team.update_attributes(owner: user)
        sign_in user
      end

      it "deletes the object" do
        expect { subject }.to change(Team, :count).by(-1)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET #rankings' do
    context "when logged in" do
      context "with an ajax request" do
        it "renders the right template" do
          user = sign_in_and_return_user
          team = create(:team, users: [user])
          get :rankings, xhr: true, params: { id: team }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/javascript")
          expect(response).to render_template("teams/rankings/rankings")
        end
      end

      context "with an html request" do
        it "renders the right template" do
          user = sign_in_and_return_user
          team = create(:team, users: [user])
          get :rankings, params: { id: team }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/html")
          expect(response).to render_template("teams/rankings/rankings")
        end
      end
    end

    context "when logged out" do
      context "with an ajax request" do
        it "returns status 401 (unauthorized)" do
          get :rankings, xhr: true, params: { id: create(:team) }

          expect(response).to have_http_status(:unauthorized)
          expect(response.content_type).to eq("text/javascript")
          expect(response).to render_template("shared/unauthorized")
        end
      end

      context "with an html request" do
        it "redirects to sign in page" do
          get :rankings, params: { id: create(:team) }

          expect(response).to have_http_status(:found)
          expect(response.content_type).to eq("text/html")
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'GET #exercises' do
    context "when logged in" do
      context "with an ajax request" do
        it "renders the right template" do
          user = sign_in_and_return_user
          team = create(:team, users: [user])
          get :exercises, xhr: true, params: { id: team }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/javascript")
          expect(response).to render_template("teams/exercises/exercises")
        end
      end

      context "with an html request" do
        it "renders the right template" do
          user = sign_in_and_return_user
          team = create(:team, users: [user])
          get :exercises, params: { id: team }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/html")
          expect(response).to render_template("teams/exercises/exercises")
        end
      end
    end

    context "when logged out" do
      context "with an ajax request" do
        it "returns status 401 (unauthorized)" do
          get :rankings, xhr: true, params: { id: create(:team) }

          expect(response).to have_http_status(:unauthorized)
          expect(response.content_type).to eq("text/javascript")
          expect(response).to render_template("shared/unauthorized")
        end
      end

      context "with an html request" do
        it "redirects to sign in page" do
          get :rankings, params: { id: create(:team) }

          expect(response).to have_http_status(:found)
          expect(response.content_type).to eq("text/html")
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'GET #users' do
    context "when logged in" do
      context "with an ajax request" do
        it "renders the right template" do
          user = sign_in_and_return_user
          team = create(:team, users: [user])
          get :users, xhr: true, params: { id: team }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/javascript")
          expect(response).to render_template("teams/users/users")
        end
      end

      context "with an html request" do
        it "renders the right template" do
          user = sign_in_and_return_user
          team = create(:team, users: [user])
          get :users, params: { id: team }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/html")
          expect(response).to render_template("teams/users/users")
        end
      end
    end

    context "when logged out" do
      context "with an ajax request" do
        it "returns status 401 (unauthorized)" do
          get :users, xhr: true, params: { id: create(:team) }

          expect(response).to have_http_status(:unauthorized)
          expect(response.content_type).to eq("text/javascript")
          expect(response).to render_template("shared/unauthorized")
        end
      end

      context "with an html request" do
        it "redirects to sign in page" do
          get :users, params: { id: create(:team) }

          expect(response).to have_http_status(:found)
          expect(response.content_type).to eq("text/html")
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'GET #graph' do
    context "when logged in" do
      context "with an ajax request" do
        it "renders the right template" do
          user = sign_in_and_return_user(teacher: true)
          team = create(:team, owner: user)
          get :graph, xhr: true, params: { id: team }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/javascript")
          expect(response).to render_template("teams/graph/graph")
        end
      end

      context "with an html request" do
        it "renders the right template" do
          user = sign_in_and_return_user(teacher: true)
          team = create(:team, owner: user)
          get :graph, params: { id: team }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("text/html")
          expect(response).to render_template("teams/graph/graph")
        end
      end
    end

    context "when logged out" do
      context "with an ajax request" do
        it "returns status 401 (unauthorized)" do
          get :graph, xhr: true, params: { id: create(:team) }

          expect(response).to have_http_status(:unauthorized)
          expect(response.content_type).to eq("text/javascript")
          expect(response).to render_template("shared/unauthorized")
        end
      end

      context "with an html request" do
        it "redirects to sign in page" do
          get :graph, params: { id: create(:team) }

          expect(response).to have_http_status(:found)
          expect(response.content_type).to eq("text/html")
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe "GET #edit" do
    let(:team) { create(:team) }
    subject { get :edit,
              params: { id: team, team: attributes_for(:team) } }

    context "when logged-in" do
      before do
        user = create(:user, :teacher)
        team.update_attributes(owner: user)
        sign_in user
        subject
      end

      it "renders edit view" do
        expect(response).to render_template(:edit)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT #update" do
    context "when logged-in -->" do
      let(:team) { create(:team, owner: user) }
      let(:user) { create(:user, :teacher) }

      before { sign_in user }

      context "whit valid attributes" do
        subject { put :update, params: { id: team,
                  team: attributes_for(:team, name: "New name") } }

        it "updates object attributes" do
          subject
          expect(team.reload.name).to eq("New name")
        end
      end

      context "whit invalid attributes" do
        before { put :update, params: {
                 id: team,
                 team: attributes_for(:team, name: nil) } }

        it "does not update object attributes" do
          expect(team.reload.name).to_not be_nil
        end
      end
    end

    context "when not logged-in" do
      before { put :update, params: { id: create(:team),
               team: attributes_for(:team, name: "New name") } }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'POST #enroll' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }
    subject(:post_with_right_password) { post :enroll, xhr: true,
             params: { id: team, password: team.password } }

    context "when logged-in -->" do
      context "when the password is right" do
        before do
          sign_in(user)
          post_with_right_password
        end

        it "enroll the user with the team" do
          expect(team.enrolled?(user)).to be_truthy
        end
      end

      context "when the password is wrong" do
        before do
          sign_in user
          post :enroll, xhr: true, params: { id: team }
        end

        it "doesn't enroll the user with the team" do
          expect(team.enrolled?(user)).to be_falsey
        end
      end
    end
  end

  describe 'POST #unenroll' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }
    subject { post :unenroll, params: { id: team } }

    context "when logged-in -->" do
      it "unenroll the user with the team" do
        expect(team.enrolled?(user)).to be_falsey
      end
    end

    context "when not logged-in" do
      before { put :update, params: { id: create(:team),
               team: attributes_for(:team, name: "New name") } }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET #answers' do
    let(:user) { create(:user, :teacher) }
    let(:team) { create(:team, owner: user) }
    subject { get :answers, xhr: true, params: { id: team } }

    context "when logged-in" do
      before do
        sign_in user
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("teams/graph/answers") }
      it { expect(assigns(:answers)).to_not be_nil }
    end

    context "when logged out" do
      before { subject }

      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
  end

  describe 'POST #add_or_remove_exercise' do
    let(:user) { create(:user, :teacher) }
    let(:team) { create(:team, owner: user) }
    let(:exercise) { create(:exercise) }

    context "when adding" do
      before do
        sign_in user
        post :add_or_remove_exercise, xhr: true,
             params: { id: team, exercise_id: exercise, operation: :add }
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("teams/add_or_remove_exercise") }
      it { expect(assigns(:team)).to_not be_nil }
      it { expect(assigns(:exercise)).to_not be_nil }
      it { expect(assigns(:team_exercises)).to_not be_nil }
      it { expect(assigns(:teacher_exercises)).to_not be_nil }
      it { expect(team.exercises.count).to eq(1) }
    end

    context "when removing" do
      before do
        sign_in user
        team.add_exercise(exercise)
        post :add_or_remove_exercise, xhr: true,
             params: { id: team, exercise_id: exercise, operation: :remove }
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("teams/add_or_remove_exercise") }
      it { expect(assigns(:team)).to_not be_nil }
      it { expect(assigns(:exercise)).to_not be_nil }
      it { expect(assigns(:team_exercises)).to_not be_nil }
      it { expect(assigns(:teacher_exercises)).to_not be_nil }
      it { expect(team.exercises.count).to eq(0) }
    end
  end

  describe "GET #list_questions" do
    let(:user) { create(:user) }
    let(:team) { create(:team, users: [user]) }
    let!(:exercise) { create(:exercise, teams: [team]) }

    subject { get :list_questions, params: { id: team, exercise_id: exercise } }

    before { sign_in user }

    it { expect(subject).to have_http_status(:ok) }

    it { expect(subject.content_type).to eq("text/html") }

    it { expect(subject).to render_template("teams/list_questions") }

    it "sets the instance variables" do
      subject
      expect(assigns(:exercise)).to_not be_nil
      expect(assigns(:dependency_checker)).to_not be_nil
    end
  end

  def sign_in_and_return_user(teacher: false)
    user = teacher ? create(:user, :teacher) : create(:user)
    sign_in user
    user
  end
end
