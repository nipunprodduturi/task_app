# frozen_string_literal: true
# spec/controllers/api/tasks_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::TasksController, type: :controller do # rubocop:disable Metrics/BlockLength
  describe 'POST #create' do # rubocop:disable Metrics/BlockLength
    let(:user) { create(:user) }
    let(:jwt_token) { JwtService.encode(user_id: user.id) }
    let(:task_attributes) { FactoryBot.attributes_for(:task) }

    before { request.headers['Authorization'] = "Bearer #{jwt_token}" }

    context 'with valid attributes' do
      it 'creates a new task' do
        expect do
          post :create, params: { task: task_attributes}
        end.to change(Task, :count).by(1)
      end

      it 'returns a JSON response with the new task' do
        post :create, params: { task: task_attributes }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).not_to be_nil
      end
    end

    context 'with invalid attributes' do
      let(:invalid_task_attributes) { FactoryBot.attributes_for(:task, title: nil) }

      it 'does not create a new task' do
        expect do
          post :create, params: { task: invalid_task_attributes }
        end.to_not change(Task, :count)
      end

      it 'returns a JSON response with errors' do
        post :create, params: { task: invalid_task_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).not_to be_empty
      end
    end
  end

  describe 'PATCH #update' do # rubocop:disable Metrics/BlockLength
    let(:user) { create(:user) }
    let(:jwt_token) { JwtService.encode(user_id: user.id) }
    let(:task) { create(:task) }
    let(:new_attributes) { { title: 'New title' } }

    before { request.headers['Authorization'] = "Bearer #{jwt_token}" }

    context 'with valid attributes' do
      it 'updates the task' do
        patch :update, params: { id: task.id, task: new_attributes }
        task.reload
        expect(task.title).to eq('New title')
      end

      it 'returns a JSON response with the updated task' do
        patch :update, params: { id: task.id, task: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['title']).to eq('New title')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { title: nil } }

      it 'does not update the task' do
        patch :update, params: { id: task.id, task: invalid_attributes }
        task.reload
        expect(task.title).not_to be_nil
      end

      it 'returns a JSON response with errors' do
        patch :update, params: { id: task.id, task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:jwt_token) { JwtService.encode(user_id: user.id) }
    let!(:task) { create(:task) }

    before { request.headers['Authorization'] = "Bearer #{jwt_token}" }

    it 'deletes the task' do
      expect do
        delete :destroy, params: { id: task.id }
      end.to change(Task, :count).by(-1)
    end

    it 'returns a JSON response with the deleted task' do
      delete :destroy, params: { id: task.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['title']).to eq(task.title)
    end
  end

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:jwt_token) { JwtService.encode(user_id: user.id) }
    let!(:tasks) { create_list(:task, 3) }

    before { request.headers['Authorization'] = "Bearer #{jwt_token}" }

    it 'returns a JSON response with all tasks' do
      expect(get(:index)).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end
