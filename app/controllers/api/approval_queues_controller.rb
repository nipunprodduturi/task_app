# frozen_string_literal: true

module Api
  # The ApprovalQueuesController is responsible for handling the approval queue actions
  class ApprovalQueuesController < ApplicationController
    before_action :authenticate_request
    before_action :set_approval, only: %i[approve reject]

    def index
      @approval_queue = ApprovalQueue.order(created_at: :asc)
      render json: @approval_queue
    end

    def approve
      if @approval_queue.update(action: 'approve')
        render json: @approval_queue.product
      else
        render json: @approval_queue.errors, status: :not_found
      end
    end

    def reject
      if @approval_queue.update(action: 'reject')
        render json: @approval_queue.product
      else
        render json: @approval_queue.errors, status: :not_found
      end
    end

    private

    def set_approval
      @approval_queue = ApprovalQueue.find(params[:id])
    rescue StandardError => e
      Rails.logger.error("Error approving product: #{e.message}")
      render json: { error: e.message }, status: :not_found
    end
  end
end
