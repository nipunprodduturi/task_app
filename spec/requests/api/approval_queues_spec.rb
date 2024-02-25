# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ApprovalQueuesController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  before { request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: user.id)}" }

  describe 'GET #index' do
    let!(:approval_queue) { create(:approval_queue) }

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns a JSON response with 1 approval queue' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    describe 'when the approval queue is nil' do
      let!(:approval_queue) { nil }

      it 'returns a JSON response with 0 approval queues' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end
    end
  end

  describe 'PUT #approve' do
    let(:product) { create(:product, status: 'active') }
    let!(:approval_queue) { create(:approval_queue, product:) }
    it 'returns a success response' do
      put :approve, params: { id: approval_queue.id }
      expect(response).to be_successful
    end

    it 'returns a JSON response with the approved product' do
      put :approve, params: { id: approval_queue.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['status']).to eq('active')
    end

    describe 'when the approval queue is nil' do
      let!(:approval_queue) { nil }

      it 'returns error response' do
        put :approve, params: { id: 1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #reject' do
    let(:product) { create(:product, status: 'active') }
    let!(:approval_queue) { create(:approval_queue, product:) }

    it 'returns a success response' do
      put :reject, params: { id: approval_queue.id }
      expect(response).to be_successful
    end

    it 'returns a JSON response with the rejected product' do
      put :reject, params: { id: approval_queue.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['status']).to eq('active')
    end

    describe 'when the approval queue is nil' do
      let!(:approval_queue) { nil }

      it 'returns a 404 response' do
        put :reject, params: { id: 1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
