# frozen_string_literal: true

# The authenticate_request method is called as a before_action in the ApiController class. This class is the base
class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JwtService.decode(header)
      @current_user = User.find(@decoded['user_id'])
    rescue JWT::DecodeError
      render json: { error: 'Token is invalid' }, status: :unauthorized
    end
  end
end
