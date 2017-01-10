require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe "GET #index" do
    subject { get :index }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders index view" do
        expect(response).to render_template(:index)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #new" do
    subject { get :new }

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
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST #create" do
    subject(:post_with_valid_attributes) { post :create,
             params: { team: attributes_for(:team) } }

    context "when logged-in -->" do
      before { sign_in create(:user) }

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

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:team) { create(:team) }
    subject { delete :destroy, params: { id: team } }

    context "when logged-in" do
      before { sign_in create(:user) }

      it "deletes the object" do
        expect { subject }.to change(Team, :count).by(-1)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #show" do
    let(:team) { create(:team) }
    subject { get :show, params: { id: team } }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders show view" do
        expect(response).to render_template(:show)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #edit" do
    let(:team) { create(:team) }
    subject { get :edit,
              params: { id: team, team: attributes_for(:team) } }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders edit view" do
        expect(response).to render_template(:edit)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "PUT #update" do
    context "when logged-in -->" do
      before { sign_in create(:user) }
      let(:team) { create(:team) }

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

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
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
          sign_in user
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

    context "when not logged-in" do
      before { post_with_right_password }

      it "resturns UNAUTHORIZED status" do
        expect(response.status).to eq(401)
      end
    end
  end
end
