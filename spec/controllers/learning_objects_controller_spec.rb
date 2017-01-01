require 'rails_helper'

RSpec.describe LearningObjectsController, type: :controller do
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
             params: { learning_object: attributes_for(:learning_object) } }

    context "when logged-in -->" do
      before { sign_in create(:user) }

      context "whit valid attributes" do
        it "creates a new learning object" do
          expect{ post_with_valid_attributes }.to change(LearningObject, :count).by(1)
        end

        it "associate the learning object to a user" do
          post_with_valid_attributes
          expect(assigns(:learning_object).user_id).to_not be_nil
        end
      end

      context "whit invalid attributes" do
        subject(:post_with_invalid_attributes) { post :create,
                params: {
                learning_object:
                attributes_for(:learning_object, title: nil) } }

        it "does not save the new learning object" do
          expect{ post_with_invalid_attributes }.to_not change(LearningObject, :count)
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
    let!(:learning_object) { create(:learning_object) }
    subject { delete :destroy, params: { id: learning_object } }

    context "when logged-in" do
      before { sign_in create(:user) }

      it "deletes the learning object" do
        expect { subject }.to change(LearningObject, :count).by(-1)
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
    let(:learning_object) { create(:learning_object) }
    subject { get :show, params: { id: learning_object } }

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
    let(:learning_object) { create(:learning_object) }
    subject { get :edit,
              params: {
              id: learning_object,
              learning_object: attributes_for(:learning_object) } }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders :edit view" do
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
      let(:learning_object) { create(:learning_object) }

      context "whit valid attributes" do
        subject { put :update, params: { id: learning_object,
                  learning_object: attributes_for(:learning_object, title: "New title") } }

        it "updates learning object attributes" do
          subject
          expect(learning_object.reload.title).to eq("New title")
        end
      end

      context "whit invalid attributes" do
        before { put :update, params: {
                 id: learning_object,
                 learning_object: attributes_for(:learning_object, title: nil) } }

        it "does not update learning object attributes" do
          expect(learning_object.reload.title).to_not be_nil
        end
      end
    end

    context "when not logged-in" do
      before { put :update, params: { id: create(:learning_object),
                learning_object: attributes_for(:learning_object, title: "New title") } }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
