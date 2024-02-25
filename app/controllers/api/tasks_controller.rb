# frozen_string_literal: true

module Api
  # This controller is responsible for managing tasks. It allows users to create, update, delete, and assign tasks.
  # It also allows users to view tasks that are overdue, tasks with a specific status, and
  # tasks that were completed within a specific date range. It also provides statistics about the tasks.
  class TasksController < ApplicationController
    before_action :authenticate_request
    before_action :set_task, only: %i[update destroy assign progress]

    def create
      @task = Task.new(task_params.merge!(user_id: @current_user.id))

      if @task.save
        render json: @task, status: :created
      else
        render_errors(@task)
      end
    end

    def update
      if @task.update(task_params)
        render json: @task
      else
        render_errors(@task)
      end
    end

    def destroy
      if @task.destroy
        render json: @task, status: :ok
      else
        render_errors(@task)
      end
    end

    def index
      @tasks = Task.all
      render json: @tasks
    end

    def assign
      @user = User.find(params[:user_id])
      @assignment = Assignment.new(task: @task, user: @user)

      if @assignment.save
        render json: @assignment, status: :created
      else
        render_errors(@assignment)
      end
    end

    def progress
      if @task.update(progress: params[:progress])
        render json: @task
      else
        render_errors(@task)
      end
    end

    def overdue
      @tasks = Task.where('due_date < ?', DateTime.now).where(status: %i[pending in_progress])
      render json: @tasks
    end

    def status
      @tasks = Task.where(status: params[:status])
      render json: @tasks
    end

    def completed
      @tasks = Task.where(completed_date: params[:start_date]..params[:end_date])
      render json: @tasks
    end

    def statistics
      total_tasks = Task.count
      completed_tasks = Task.where(status: :completed).count
      percentage_completed = total_tasks.zero? ? 0 : (completed_tasks.to_f / total_tasks) * 100

      render json: { total_tasks:, completed_tasks:, percentage_completed: }
    end

    def priority
      @next_task = TaskQueueService.next_task
      render json: @next_task
    end

    private

    def set_task
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("Task not found: #{params[:id]}")
      render json: { error: 'Task not found' }, status: :not_found
    end

    def task_params
      params.require(:task).permit(:title, :description, :due_date, :status, :progress, :priority, :user_id)
    end

    def render_errors(record)
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
