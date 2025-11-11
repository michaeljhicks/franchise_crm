require 'rails_helper'

RSpec.describe "GoogleConnections", type: :request do
  describe "GET /destroy" do
    it "returns http success" do
      get "/google_connections/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
