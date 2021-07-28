class  Api::V1::UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token, raise: false
  #before_action :authenticate

  def create
    user_data = User.find_by email: auth_params[:email]

    final_data = {
      "data": {
        "id": user_data['id'],
        "type": "users",
        "attributes": {
          "token": auth_token.token,
          "email": user_data['email'],
          "name": user_data['firstName']+" "+user_data['lastName'],
          "country": user_data['country'],
          "createdAt": user_data['created_at'],
          "updatedAt": user_data['updated_at']
        }
      }
    }
    render json: final_data, status: :created

  end
end
