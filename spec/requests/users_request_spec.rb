require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "Signup" do
    context "with valid attributes" do
      it "creates a new user" do
        post '/api/v1/users/signup', params: { firstName: "Jean", lastName: "Doe", email: "jeandoe@mail.com",password: "newuser123", country: "Iceland" }
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "Signup" do
    context "with uncompleted attributes" do
      it "creates a new user" do
        post '/api/v1/users/signup', params: { firstName: "Jean", lastName: "Doe", email: "jeandoe@mail.com", country: "Iceland" }
        expect(response).to raise_error("Validation failed: Password can't be blank")
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "Signin" do
    context "with correct parameter" do
      it "gains authentication token" do
        post '/auth/signin', params: { email: "jeandoe@mail.com", password: "newuser123"}
        expect(response).to have_http_status(:ok)
      end
    end
  end

end
