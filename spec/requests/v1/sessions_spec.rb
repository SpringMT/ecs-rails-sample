require "rails_helper"

RSpec.describe "V1::Sessions", type: :request do
  include_context "request_spec_helper"

  let(:user_id) { "123" }
  describe "GET /v1/sessions/:id" do
    context "正常系" do
      let(:session) { create(:session, :active, user_id: user_id) }
      it "セッションがあればそれが返る" do
        get v1_session_path session.id, headers: client_headers
        expect(response).to have_http_status(200)
        response_data = JSON.parse(response.body, symbolize_names: true)
        expect(response_data).to eq({ user_id: user_id, session_id: session.id })
      end
    end
  end

  describe "POST /v1/sessions" do
    context "正常系" do
      it "セッションがなければ新規作成" do
        post v1_sessions_path, params: { user_id: user_id }, as: :json, headers: client_headers
        expect(response).to have_http_status(200)
        response_data = JSON.parse(response.body, symbolize_names: true)
        expect(response_data[:last_session_updated_at]).to eq(nil)
      end
    end
  end
end
