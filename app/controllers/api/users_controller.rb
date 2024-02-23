# frozen_string_literal: true

module Api
  # This controller is responsible for managing users. It allows users to view their tasks.
  class UsersController < ApplicationController
    before_action :authenticate_request

    def tasks
      @user = User.find(params[:id])
      @tasks = @user.tasks
      if @tasks.present?
        render json: @tasks
      else
        render json: { error: 'User has no tasks' }, status: :not_found
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end
