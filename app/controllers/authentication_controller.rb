# frozen_string_literal: true

# This controller is responsible for authenticating the user and returning a JWT token if the user is authenticated.
class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # The authenticate method is called when a user logs in. It checks if the user exists and if the password is correct. If the user is authenticated, a JWT token is returned.
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
