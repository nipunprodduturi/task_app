require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe 'GET #tasks' do # rubocop:disable Metrics/BlockLength
    let(:user) { create(:user) }

    context 'when user has tasks' do
      before do
        allow_any_instance_of(Api::UsersController).to receive(:authenticate_request).and_return(true)
      end
      let!(:task) { create(:task, user_id: user.id) }

      it 'returns a JSON response with the user tasks' do
        get :tasks, params: { id: user.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).first['id']).to eq(task.id)
      end
    end

    context 'when user has no tasks' do
      before do
        allow_any_instance_of(Api::UsersController).to receive(:authenticate_request).and_return(true)
      end

      it 'returns a JSON response with an error message' do
        get :tasks, params: { id: user.id }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User has no tasks')
      end
    end

    context 'when user does not exist' do
      before do
        allow_any_instance_of(Api::UsersController).to receive(:authenticate_request).and_return(true)
      end
      it 'returns a JSON response with an error message' do
        get :tasks, params: { id: 999 } # Assuming user with ID 999 does not exist
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
      end
    end

    context 'when user is not authenticated' do
      it 'returns a JSON response with an error message' do
        expect do
          
        end
      end
    end
  end
end
