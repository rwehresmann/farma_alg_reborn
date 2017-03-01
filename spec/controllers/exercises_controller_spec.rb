require 'rails_helper'

RSpec.describe ExercisesController, type: :controller do
  let(:teacher) { create(:user, :teacher) }

  describe "GET #index" do
    subject { get :index }

    context "when logged-in" do
      before do
        sign_in teacher
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
        sign_in teacher
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
             params: { exercise: attributes_for(:exercise) } }

    context "when logged-in -->" do
      before { sign_in teacher }

      context "whit valid attributes" do
        it "creates a new object" do
          expect{ post_with_valid_attributes }.to change(Exercise, :count).by(1)
        end

        it "associate the object to a user" do
          post_with_valid_attributes
          expect(assigns(:exercise).user_id).to_not be_nil
        end
      end

      context "whit invalid attributes" do
        subject(:post_with_invalid_attributes) { post :create,
                params: {
                exercise:
                attributes_for(:exercise, title: nil) } }

        it "does not save the new object" do
          expect{ post_with_invalid_attributes }.to_not change(Exercise, :count)
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
    let!(:exercise) { create(:exercise, user: teacher) }
    subject { delete :destroy, params: { id: exercise } }

    context "when logged-in" do
      before { sign_in teacher }

      it "deletes the object" do
        expect { subject }.to change(Exercise, :count).by(-1)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "GET #show" do
    let(:exercise) { create(:exercise) }
    subject { get :show, params: { id: exercise } }

    context "when logged-in" do
      before do
        sign_in teacher
        subject
      end

      it "renders show view" do
        expect(response).to render_template(:show)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "GET #edit" do
    let(:exercise) { create(:exercise, user: teacher) }

    subject { get :edit,
              params: {
              id: exercise,
              exercise: attributes_for(:exercise) } }

    context "when logged-in" do
      before do
        sign_in teacher
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
      before { sign_in teacher }
      let(:exercise) { create(:exercise, user: teacher) }

      context "whit valid attributes" do
        subject { put :update, params: { id: exercise,
                  exercise: attributes_for(:exercise, title: "New title") } }

        it "updates object attributes" do
          subject
          expect(exercise.reload.title).to eq("New title")
        end
      end

      context "whit invalid attributes" do
        before { put :update, params: {
                 id: exercise,
                 exercise: attributes_for(:exercise, title: nil) } }

        it "does not update object attributes" do
          expect(exercise.reload.title).to_not be_nil
        end
      end
    end

    context "when not logged-in" do
      before { put :update, params: { id: create(:exercise),
               exercise: attributes_for(:exercise, title: "New title") } }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
