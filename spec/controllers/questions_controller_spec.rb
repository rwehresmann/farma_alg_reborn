require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe "GET #index" do
    let(:exercise) { create(:exercise) }
    subject { get :index, params: { exercise_id: exercise } }

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
    let(:exercise) { create(:exercise) }
    subject { get :new, params: { exercise_id: exercise } }

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
    let(:exercise) { create(:exercise) }
    subject(:post_with_valid_attributes) { post :create,
             params: params }

    context "when logged-in -->" do
      before { sign_in create(:user, :teacher) }

      context "whit valid attributes" do
        let(:params) { { question: attributes_for(:question),
                         exercise_id: exercise } }

        it "creates a new object" do
          expect{ post_with_valid_attributes }.to change(Question, :count).by(1)
        end

        context "when dependencies are defined" do
          let!(:questions) { create_pair(:question, exercise: exercise) }

          before do
            params[:"question-#{questions.first.id}"] = "OR"
            params[:"question-#{questions.last.id}"] = ""
          end

          it "creates a new object" do
            expect{ post_with_valid_attributes }.to change(Question, :count).by(1)
          end

          it "creates the question dependencies" do
            expect { post_with_valid_attributes }.to change(QuestionDependency, :count).by(2)
          end
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
      let(:params) { { question: attributes_for(:question),
                       exercise_id: exercise } }
      before { post_with_valid_attributes }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "GET #show" do
    let(:question) { create(:question) }
    subject { get :show, params: { id: question } }

    context "when logged-in" do
      before do
        sign_in create(:user, :teacher)
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
    let(:question) { create(:question) }
    subject { get :edit,
              params: {
              id: question,
              question: question } }

    context "when logged-in" do
      before do
        sign_in create(:user, :teacher)
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
    let(:questions) do
      exercise = create(:exercise)
      create_pair(:question, exercise: exercise)
    end

    subject { put :update, params: params }

    context "when logged-in -->" do
      before { sign_in create(:user, :teacher) }

      context "whit valid attributes" do
        let(:params) { { id: questions.first,
                         question: attributes_for(:question, description: "New description") } }

        it "updates object attributes" do
          subject
          expect(questions.first.reload.description).to eq("New description")
        end

        context "when dependency is marked to be deleted" do
          before do
            QuestionDependency.create_symmetrical_record(questions.first,
                                                         questions.last, "OR")
            params[:"question-#{questions.last.id}"] = ""
          end

          it "deletes the dependency" do
            expect { subject }.to change(QuestionDependency, :count).by(-2)
          end
        end

        context "when dependency is marked to be changed" do
          before do
            QuestionDependency.create_symmetrical_record(questions.first,
                                                         questions.last, "OR")
            params[:"question-#{questions.last.id}"] = "AND"
            subject
          end

          it "changes the dependency operator" do
            expect(questions.first.dependency_with(questions.last)).to eq("AND")
          end
        end

        context "when dependencies are created" do
          before { params[:"question-#{questions.last.id}"] = "AND" }

          it "created the dependency" do
            expect { subject }.to change(QuestionDependency, :count).by(2)
          end
        end
      end

      context "whit invalid attributes" do
        before { put :update, params: {
                 id: questions.first,
                 question: attributes_for(:question, description: nil) } }

        it "does not update object attributes" do
          expect(questions.first.reload.description).to_not be_nil
        end
      end
    end

    context "when not logged-in" do
      before { put :update, params: {
               id: questions.first,
               question: attributes_for(:question, description: "New description") } }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:exercise) { create(:exercise) }
    let(:questions) { create_pair(:question, exercise: exercise) }

    before do
      QuestionDependency.create_symmetrical_record(questions.first,
                                                   questions.last, "OR")
    end

    subject { delete :destroy, params: { id: questions.first } }

    context "when logged-in" do
      before { sign_in create(:user, :teacher) }

      it "deletes the object" do
        expect { subject }.to change(Question, :count).by(-1)
      end

      it "deletes the question dependencies" do
        expect { subject }.to change(QuestionDependency, :count).by(-2)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
