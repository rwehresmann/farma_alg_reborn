require 'rails_helper'

RSpec.describe GraphController, type: :controller do
  describe 'GET #search_answers' do
    let(:teacher) { create(:user, :teacher) }
    let!(:team) { create(:team, owner: teacher) }
    subject { get :search_answers, xhr: true, params: { team_id: team } }

    context "when logged-in -->" do
      before do
        sign_in teacher
        subject
      end

      it "assigns a collection of answers to @answers" do
        expect(assigns(:answers)).to_not be_nil
      end
    end
  end

  describe 'GET #connections' do
    let(:teacher) { create(:user, :teacher) }
    let(:answer) { create(:answer) }
    subject { get :connections, xhr: true, params: { target_answer: answer,
                                                      answers: [] } }

    context "when logged-in -->" do
      before do
        sign_in teacher
        subject
      end

      it "assigns a collection of answers to @answers" do
        expect(assigns(:connections)).to_not be_nil
      end
    end
  end

  describe 'GET #answers' do
    let(:teacher) { create(:user, :teacher) }
    let(:answer) { create(:answer) }
    subject { get :answers, xhr: true, params: { answers_ids: answer } }

    context "when logged-in -->" do
      before do
        sign_in teacher
        subject
      end

      it "assigns a collection of answers to @answers" do
        expect(assigns(:answers)).to_not be_nil
      end
    end
  end
end
