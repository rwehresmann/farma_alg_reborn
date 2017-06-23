require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe "GET #index" do
    context "when logged in" do
      it do
        sign_in create(:user)
        get :index

        common_expectations(
          http_status: :ok,
          content_type: "text/html",
          template: "messages/index"
        )
      end
    end

    context "when logged out" do
      it do
        get :index

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe "GET #new" do
    subject {
      get :new, params: {
        receiver_ids: [create(:user).id],
        previous_message_id: create(:answer).id
      }
    }

    context "when logged in" do
      it do
        sign_in create(:user)

        subject

        common_expectations(
          http_status: :ok,
          content_type: "text/html",
          template: "messages/new"
        )
      end
    end

    context "when logged out" do
      it do
        subject

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe "GET #create" do
    context "when logged in" do
      context "and message title is empty" do
        it do
          sign_in create(:user)

          expect {
            post :create, {
              params: {
                receiver_ids: [create(:user)],
                message: attributes_for(:message, title: "")
              }
            }
          }.to_not change(Message, :count)

          expect(flash[:danger]).to_not be_nil
          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "messages/new"
          )
        end
      end

      context "and message content is empty" do
        it do
          sign_in create(:user)

          expect {
            post :create, {
              params: {
                receiver_ids: [create(:user)],
                message: attributes_for(:message, content: "")
              }
            }
          }.to_not change(Message, :count)

          expect(flash[:danger]).to_not be_nil
          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "messages/new"
          )
        end
      end

      context "and there aren't receivers specified" do
        it do
          sign_in create(:user)

          expect {
            post :create, {
              params: {
                message: attributes_for(:message)
              }
            }
          }.to_not change(Message, :count)

          expect(flash[:danger]).to_not be_nil
          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "messages/new"
          )
        end
      end

      context "and all attributes are valid" do
        it do
          sign_in create(:user)

          expect {
            post :create, {
              params: {
                receiver_ids: [create(:user)],
                message: attributes_for(:message)
              }
            }
          }.to change(Message, :count).by(1)

          expect(flash[:success]).to_not be_nil
          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: messages_url
          )
        end
      end
    end

    context "when logged out" do
      it do
        expect {
          post :create, {
            params: {
              receiver_ids: [create(:user)],
              message: attributes_for(:message, title: "")
            }
          }
        }.to_not change(Message, :count)

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  describe "GET #show" do
    context "when logged in" do
      context "when message belongs to him" do
        it do
          user = create(:user)
          sign_in user
          get :show, params: { id: create(:message, sender: user) }

          common_expectations(
            http_status: :ok,
            content_type: "text/html",
            template: "messages/show"
          )
        end
      end

      context "when messag doesn't belongs to him" do
        it do
          sign_in create(:user)
          get :show, params: { id: create(:message) }

          expect(flash[:warning]).to_not be_nil
          common_expectations(
            http_status: :found,
            content_type: "text/html",
            redirect: root_url
          )
        end
      end
    end

    context "when logged out" do
      it do
        get :show, params: { id: create(:message) }

        common_expectations(
          http_status: :found,
          content_type: "text/html",
          redirect: root_url
        )
      end
    end
  end

  def common_expectations(args = {})
    expect(response).to have_http_status args[:http_status] if args[:http_status]
    expect(response.content_type).to eq args[:content_type] if args[:content_type]
    expect(response).to render_template args[:template] if args[:template]
    expect(response).to redirect_to args[:redirect] if args[:redirect]
  end
end
