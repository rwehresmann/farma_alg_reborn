require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe 'GET #index' do
    context "when logged in" do
      context "with an html request" do
        it "renders the right template" do
          sign_in create(:user)
          get :index

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/index"
          )
        end
      end

      context "with an ajax request" do
        it "renders the right template" do
          sign_in create(:user)
          get :index, xhr: true

          common_expectations(
            http_status: :ok,
            content_type: "text/javascript",
            template: "teams/index"
          )
        end
      end
    end

    context "when logged out" do
      context "with an html request" do
        it "does an redirect" do
          get :index

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end

      context "with an ajax request" do
        it "returns code 401 (unauthorized)" do
          get :index, xhr: true

          common_expectations(
            http_status: :unauthorized,
            content_type: "text/javascript",
            template: "shared/unauthorized"
          )
        end
      end
    end
  end

  describe 'GET #new' do
    context "when logged in" do
      context "when is a normal user" do
        it "does an redirect" do
          sign_in create(:user)
          get :new

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end

      context "when is a teacher" do
        it "renders the right template" do
          sign_in create(:user, :teacher)
          get :new

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/new"
          )
        end
      end
    end

    context "when logged out" do
      it "does an redirect" do
        get :new

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe 'POST #create' do
    context "when logged in" do
      context "with a normal user" do
        it "doesn't create the team" do
          before_count = Team.count

          sign_in create(:user)
          post :create, params: { team: attributes_for(:team) }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )

          expect(Team.count).to eq before_count
        end
      end

      context "with a teacher user" do
        context "and team is valid" do
          it "creates the team" do
            before_count = Team.count

            sign_in create(:user, :teacher)
            post :create, params: { team: attributes_for(:team) }

            common_expectations(
              http_status: :found,
              content_type: "text/html",
              redirect: teams_url
            )

            expect(Team.count).to eq(before_count + 1)
          end
        end

        context "and team is invalid" do
          it "doesn't create the team" do
            before_count = Team.count

            sign_in create(:user, :teacher)
            post :create, params: { team: attributes_for(:team, name: "") }

            common_expectations(
              http_status: :ok,
              content_type: "text/html",
              template: "teams/new"
            )

            expect(Team.count).to eq before_count
          end
        end
      end
    end

    context "when logged out" do
      it "does a redirect" do
        post :create, params: { team: attributes_for(:team) }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe 'GET #edit' do
    context "when logged in" do
      context "with a normal user" do
        it "does a redirect" do
          sign_in create(:user)
          get :edit, params: { id: create(:team) }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end

      context "with a teacher user" do
        context "when the team belongs to him" do
          it "renders the right template" do
            user = create(:user, :teacher)

            sign_in user
            get :edit, params: { id: create(:team, owner: user) }

            common_expectations(
              http_status: :ok,
              content_type: "text/html",
              template: "teams/edit"
            )
          end
        end

        context "when the team doesn't belongs to him" do
          it "does a redirect" do
            sign_in create(:user, :teacher)
            get :edit, params: { id: create(:team) }

            common_expectations(
              http_status: :found,
              content_type: "text/html",
              redirect: root_url
            )
          end
        end
      end
    end

    context "when logged out" do
      it "does a redirect" do
        get :edit, params: { id: create(:team) }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe 'PUT update' do
    context "when logged in" do
      context "with a normal user" do
        it "doesn't update the team" do
          team = create(:team)

          sign_in create(:user)
          put :update, params: { id: team, team: attributes_for(:team, name: "new name") }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )

          expect(team.name).to eq team.reload.name
        end
      end

      context "with a teacher user" do
        context "when the team belongs to him" do
          context "and is valid" do
            it "updates the team" do
              user = create(:user, :teacher)
              team = create(:team, owner: user)

              sign_in user
              put :update, params: { id: team, team: attributes_for(:team, name: "new name") }

              common_expectations(
                http_status: :found,
                content_type: "text/html",
                redirect: teams_url
              )

              expect(team.name).to_not eq team.reload.name
            end
          end

          context "and is invalid" do
            it "doesn't updates the team" do
              user = create(:user, :teacher)
              team = create(:team, owner: user)

              sign_in user
              put :update, params: { id: team, team: attributes_for(:team, name: "") }

              common_expectations(
                http_status: :ok,
                content_type: "text/html",
                template: "teams/edit"
              )

              expect(team.name).to eq team.reload.name
            end
          end
        end

        context "when the team doesn't belongs to him" do
          it "doesn't updates the team" do
            team = create(:team)

            sign_in create(:user, :teacher)
            put :update, params: { id: team, team: attributes_for(:team, name: "new name") }

            common_expectations(
              http_status: :found,
              content_type: "text/html",
              redirect: root_url
            )

            expect(team.name).to eq team.reload.name
          end
        end
      end
    end

    context "when logged out" do
      it "doesn't updates the team" do
        team = create(:team, owner: create(:user, :teacher))

        put :update, params: { id: team, team: attributes_for(:team, name: "new name") }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )

        expect(team.name).to eq team.reload.name
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when logged in" do
      context "with a normal user" do
        it "doesn't deletes the team" do
          team = create(:team)
          before_count = Team.count

          sign_in create(:user)
          delete :destroy, params: { id: team }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )

          expect(Team.count).to eq before_count
        end
      end

      context "with a teacher user" do
        context "when team belogns to him" do
          it "deletes the team" do
            user =  create(:user, :teacher)

            sign_in user
            delete :destroy, params: { id: create(:team, owner: user) }

            common_expectations(
              http_status: :found,
              content_type: "text/html",
              redirect: teams_url
            )

            expect(Team.count).to eq 0
          end
        end

        context "when team doesn't belongs to him" do
          it "doesn't deletes the team" do
            team = create(:team)
            before_count = Team.count

            sign_in create(:user, :teacher)
            delete :destroy, params: { id: team }

            common_expectations(
              http_status: :found,
              content_type: "text/html",
              redirect: root_url
            )

            expect(Team.count).to eq before_count
          end
        end
      end
    end

    context "when logged out" do
      it "doesn't deletes the team" do
        team =  create(:team)
        before_count = Team.count

        delete :destroy, params: { id: team }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )

        expect(Team.count).to eq before_count
      end
    end
  end

  describe 'GET #rankings' do
    context "when logged in" do
      context "when user is the owner of the team" do
        it "renders the right template" do
          user = create(:user, :teacher)

          sign_in user
          get :rankings, params: { id: create(:team, owner: user) }

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/rankings"
          )
        end
      end

      context "when user is enrolled in the team" do
        it "renders the right template" do
          user = create(:user)

          sign_in user
          get :rankings, params: { id: create(:team, users: [user]) }

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/rankings"
          )
        end
      end

      context "when user doesn't belongs to the team" do
        it "does a redirect" do
          sign_in create(:user)
          get :rankings, params: { id: create(:team) }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end
    end

    context "when logged out" do
      it "does a redirect" do
        user = create(:user)

        get :rankings, params: { id: create(:team, users: [user]) }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe 'GET #exercises' do
    context "when logged in" do
      context "when user is the owner of the team" do
        it "renders the right template" do
          user = create(:user, :teacher)

          sign_in user
          get :exercises, params: { id: create(:team, owner: user) }

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/exercises"
          )
        end
      end

      context "when user is enrolled in the team" do
        context "with an html request" do
          it "renders the right template" do
            user = create(:user)

            sign_in user
            get :exercises, params: { id: create(:team, users: [user]) }

            common_expectations(
              http_status: :ok,
              content_type: "text/html",
              template: "teams/exercises"
            )
          end
        end

        context "with an ajax request" do
          it "renders the right template" do
            user = create(:user)

            sign_in user
            get :exercises, xhr: true, params: { id: create(:team, users: [user]) }

            common_expectations(
              http_status: :ok,
              content_type: "text/javascript",
              template: "teams/exercises"
            )
          end
        end
      end

      context "when user doesn't belongs to the team" do
        context "with an html request" do
          it "does a redirect" do
            sign_in create(:user)
            get :exercises, params: { id: create(:team) }

            common_expectations(
              http_status: :found,
              content_type: "text/html",
              redirect: root_url
            )
          end
        end

        context "with an ajax request" do
          it "returns status 401 (unauthorized)" do
            sign_in create(:user)
            get :exercises, xhr: true, params: { id: create(:team) }

            common_expectations(
              http_status: :unauthorized,
              content_type: "text/javascript",
              template: "shared/unauthorized"
            )
          end
        end
      end
    end

    context "when logged out" do
      context "with an html request" do
        it "does a redirect" do
          user = create(:user)

          get :exercises, params: { id: create(:team, users: [user]) }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end

      context "with an ajax request" do
        it "returns status 401 (unauthorized)" do
          user = create(:user)

          get :exercises, xhr: true, params: { id: create(:team, users: [user]) }

          common_expectations(
            http_status: :unauthorized,
            content_type: "text/javascript",
            template: "shared/unauthorized"
          )
        end
      end
    end
  end

  describe 'GET #users' do
    context "when logged in" do
      context "when user is the owner of the team" do
        it "renders the right template" do
          user = create(:user, :teacher)

          sign_in user
          get :users, params: { id: create(:team, owner: user) }

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/users"
          )
        end
      end

      context "when user is enrolled in the team" do
        it "renders the right template" do
          user = create(:user)

          sign_in user
          get :users, params: { id: create(:team, users: [user]) }

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/users"
          )
        end
      end

      context "when user doesn't belongs to the team" do
        it "does a redirect" do
          sign_in create(:user)
          get :users, params: { id: create(:team) }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end
    end

    context "when logged out" do
      it "does a redirect" do
        user = create(:user)

        get :users, params: { id: create(:team, users: [user]) }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe 'GET #graph' do
    context "when logged in" do
      context "when user is the owner of the team" do
        it "renders the right template" do
          user = create(:user, :teacher)

          sign_in user
          get :graph, params: { id: create(:team, owner: user) }

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/graph"
          )
        end
      end

      context "when user is enrolled in the team" do
        it "renders the right template" do
          user = create(:user, :teacher)

          sign_in user
          get :graph, params: { id: create(:team, users: [user]) }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end

      context "when user doesn't belongs to the team" do
        it "does a redirect" do
          sign_in create(:user)
          get :graph, params: { id: create(:team) }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end
    end

    context "when logged out" do
      it "does a redirect" do
        user = create(:user)

        get :graph, params: { id: create(:team, users: [user]) }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe 'POST #enroll' do
    context "when logged in" do
      context "when user is the owner of the team" do
        it "doesn't enroll the user" do
          user = create(:user, :teacher)
          team = create(:team, owner: user)

          sign_in user
          post :enroll, xhr: true, params: { id: team }

          common_expectations(
            http_status: :unauthorized,
            content_type: "text/javascript",
            template: "shared/unauthorized"
          )

          expect(team.users).to be_empty
        end
      end

      context "when user isn't the owner of the team" do
        context "when user isn't enrolled yet" do
          context "when passwords match"
          it "enroll the user" do
            user = create(:user, :teacher)
            team = create(:team)
            before_count = team.users.count

            sign_in user
            post :enroll, xhr: true, params: { id: team, password: team.password }

            common_expectations(
              http_status: :ok,
              content_type: "text/javascript",
              template: "teams/enroll"
            )

            expect(team.users.count).to eq(before_count + 1)
          end
        end

        context "when user is already enrolled" do
          it "doesn't enroll him again" do
            user = create(:user)
            team = create(:team, users: [user])

            sign_in user
            post :enroll, xhr: true, params: { id: team }

            common_expectations(
              http_status: :unauthorized,
              content_type: "text/javascript",
              template: "shared/unauthorized"
            )

            expect(team.users.count).to eq 1
          end
        end
      end
    end

    context "when logged out" do
      it "doesn't enroll the user" do
        team = create(:team)
        post :enroll, xhr: true, params: { id: team, password: team.password }

        common_expectations(
          http_status: :unauthorized,
          content_type: "text/javascript",
          template: "shared/unauthorized"
        )

        expect(team.users).to be_empty
      end
    end
  end

  describe 'POST #unenroll' do
    context "when logged in" do
      context "when user is enrolled in the team" do
        it "unenrolls him" do
          user = create(:user)
          team = create(:team, users: [user])

          sign_in user
          post :unenroll, params: { id: team }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: teams_url
          )

          expect(team.reload.users).to be_empty
        end
      end

      context "when user isn't enrolled in the team" do
        it "does a redirect" do
          team = create(:team)

          sign_in create(:user)
          post :unenroll, params: { id: team }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )

          expect(team.reload.users).to be_empty
        end
      end
    end

    context "when logged out" do
      it "doesn't unenroll the user" do
        user = create(:user)
        team = create(:team, users: [user])

        post :unenroll, params: { id: team }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )

        expect(team.reload.users.count).to eq 1
      end
    end
  end

  describe 'GET #list_questions' do
    context "when logged in" do
      context "when is enrolled in the team" do
        it "renders the right template" do
          user = create(:user)
          exercise = create(:exercise)
          team = create(:team, users: [user], exercises: [exercise])

          sign_in user
          get :list_questions, params: { id: team, exercise_id: exercise }

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "teams/list_questions"
          )
        end
      end

      context "when isn't enrolled in the team" do
        it "does a redirect" do
          exercise = create(:exercise)
          team = create(:team, exercises: [exercise])

          sign_in create(:user)
          get :list_questions, params: { id: team, exercise_id: exercise }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end

      context "when is the owner of the team" do
        it "does a redirect" do
          user = create(:user, :teacher)
          exercise = create(:exercise)
          team = create(:team, owner: user, exercises: [exercise])

          sign_in user
          get :list_questions, params: { id: team, exercise_id: exercise }

          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end
    end

    context "when logged out" do
      it "does a redirect" do
        exercise = create(:exercise)
        team = create(:team, exercises: [exercise])

        get :list_questions, params: { id: team, exercise_id: exercise }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  # TODO: rewrite tests after action reimplementation.
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

  def common_expectations(args = {})
    expect(response).to have_http_status args[:http_status] if args[:http_status]
    expect(response.content_type).to eq args[:content_type] if args[:content_type]
    expect(response).to render_template args[:template] if args[:template]
    expect(response).to redirect_to args[:redirect] if args[:redirect]
  end
end
