require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "DELETE #destroy" do
    let(:user) { create(:user, :teacher) }
    let!(:comment) { create(:comment, user: user) }

    subject { delete :destroy, xhr: true, params: { id: comment }  }

    context "when logged-in" do
      before do
        sign_in user
        subject
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to eq("text/javascript") }
      it { expect(response).to render_template("comments/destroy") }
    end

    context "when logged-out" do
      before { subject }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(flash[:warning]).to_not be_nil }
      it { expect(response).to render_template("shared/unauthorized") }
    end
  end

end
