require 'rails_helper'

RSpec.describe TestCasesController, type: :controller do
  let(:teacher) { create(:user, :teacher) }
  let(:exercise) { create(:exercise, user: teacher) }
  let(:question) { create(:question, exercise: exercise) }

  describe "GET #index" do
    subject { get :index, params: { question_id: question } }

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
    subject { get :new, params: { question_id: question } }

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
             params: { test_case: attributes_for(:test_case),
                       question_id: question } }

    context "when logged-in -->" do
      before { sign_in teacher }

      context "whit valid attributes" do
        it "creates a new object" do
          expect{ post_with_valid_attributes }.to change(TestCase, :count).by(1)
        end
      end

      context "whit invalid attributes" do
        subject(:post_with_invalid_attributes) { post :create,
                params: {
                test_case:
                attributes_for(:test_case, output: nil),
                question_id: question } }

        it "does not save the new object" do
          expect{ post_with_invalid_attributes }.to_not change(TestCase, :count)
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

  describe "GET #show" do
    let(:test_case) { create(:test_case, question: question) }
    subject { get :show, params: { id: test_case } }

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
    let(:test_case) { create(:test_case, question: question) }
    subject { get :edit,
              params: {
              id: test_case,
              test_case: test_case } }

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
    let(:test_case) { create(:test_case, question: question) }

    context "when logged-in -->" do
      before { sign_in teacher }

      context "whit valid attributes" do
        subject { put :update, params: {
                  id: test_case,
                  test_case: attributes_for(:test_case, output: "New output") } }

        it "updates object attributes" do
          subject
          expect(test_case.reload.output).to eq("New output")
        end
      end

      context "whit invalid attributes" do
        before { put :update, params: {
                 id: test_case,
                 test_case: attributes_for(:test_case, output: nil) } }

        it "does not update object attributes" do
          expect(test_case.reload.output).to_not be_nil
        end
      end
    end

    context "when not logged-in" do
      before { put :update, params: {
               id: test_case,
               question: attributes_for(:question, description: "New description") } }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:test_case) { create(:test_case, question: question) }
    subject { delete :destroy, params: { id: test_case } }

    context "when logged-in" do
      before { sign_in teacher }

      it "deletes the object" do
        expect { subject }.to change(TestCase, :count).by(-1)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'POST #run' do
    let(:test_case) { create(:test_case) }
    let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
    subject { post :test, xhr: true,
              params: { id: test_case.id, source_code: source_code } }

    context "when logged-in" do
      before { sign_in teacher }

      it "resturns OK status" do
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST #run_all' do
    let(:question) { create(:question) }
    let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
    subject { post :test_all, xhr: true,
              params: { question_id: question.id, source_code: source_code } }

    context "when logged-in" do
      before { sign_in teacher }

      it "returns OK status" do
        expect(response.status).to eq(200)
      end
    end
  end
end
