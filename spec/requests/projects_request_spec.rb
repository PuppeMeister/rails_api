require 'rails_helper'

RSpec.describe "Projects", type: :request do

  describe "GET /project/:id" do
    it "returns http success" do
      get "/api/v1/projects/1"
      expect(response).to have_http_status(:ok)
    end
  end

end
