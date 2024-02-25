# frozen_string_literal: true

# This controller is responsible for authenticating the user and returning a JWT token if the user is authenticated.
class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: { token: }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
