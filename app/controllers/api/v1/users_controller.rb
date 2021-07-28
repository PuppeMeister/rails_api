class Api::V1::UsersController < ApplicationController

  def signup
    @user = User.create!(user_params)
    if @user.save
      final_data = final_data = {
        "data": {
          "id": @user['id'],
          "type": "users",
          "attributes": {
            "email": @user['email'],
            "name": @user['firstName']+" "+@user['lastName'],
            "country": @user['country'],
            "createdAt": @user['created_at'],
            "updatedAt": @user['updated_at']
          }
        }
      }
      render(json: final_data, status: :created)
    else
      render(json: @user.errors, status: :unprocessable_entity)
    end
  end

  private

  def user_params
    params.permit(:firstName, :lastName, :email, :password, :country)
  end
end
