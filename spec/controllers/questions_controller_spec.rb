require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe "GET #index" do
    let(:exercise) { create(:exercise) }
    subject { get :index, params: { exercise_id: exercise } }

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
    let(:exercise) { create(:exercise) }
    subject { get :new, params: { exercise_id: exercise } }

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
    let(:exercise) { create(:exercise) }
    subject(:post_with_valid_attributes) { post :create,
             params: { question: attributes_for(:question),
                       exercise_id: exercise } }

    context "when logged-in -->" do
      before { sign_in create(:user) }

      context "whit valid attributes" do
        it "creates a new object" do
          expect{ post_with_valid_attributes }.to change(Question, :count).by(1)
        end
      end

      context "whit invalid attributes" do
        subject(:post_with_invalid_attributes) { post :create,
                params: {
                question:
                attributes_for(:question, description: nil),
                exercise_id: exercise } }

        it "does not save the new object" do
          expect{ post_with_invalid_attributes }.to_not change(Question, :count)
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

  describe "GET #show" do
    let(:question) { create(:question) }
    subject { get :show, params: { id: question } }

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
    let(:question) { create(:question) }
    subject { get :edit,
              params: {
              id: question,
              question: question } }

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
    let(:question) { create(:question) }

    context "when logged-in -->" do
      before { sign_in create(:user) }

      context "whit valid attributes" do
        subject { put :update, params: {
                  id: question,
                  question: attributes_for(:question, description: "New description") } }

        it "updates object attributes" do
          subject
          expect(question.reload.description).to eq("New description")
        end
      end

      context "whit invalid attributes" do
        before { put :update, params: {
                 id: question,
                 question: attributes_for(:question, description: nil) } }

        it "does not update object attributes" do
          expect(question.reload.description).to_not be_nil
        end
      end
    end

    context "when not logged-in" do
      before { put :update, params: {
               id: question,
               question: attributes_for(:question, description: "New description") } }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:question) { create(:question) }
    subject { delete :destroy, params: { id: question } }

    context "when logged-in" do
      before { sign_in create(:user) }

      it "deletes the object" do
        expect { subject }.to change(Question, :count).by(-1)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
