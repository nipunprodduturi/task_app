# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ProductsController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }

  before { request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: user.id)}" }
  before do
    Product.create([{ name: 'Product 1', price: 100, status: 'active'},
                    { name: 'Product 2', price: 200, status: 'inactive', created_at: 1.day.ago},
                    { name: 'Product 3', price: 300, status: 'active', created_at: 2.days.ago }])
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns a JSON response with 2 active products' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET #search' do
    it 'returns a success response' do
      get :search
      expect(response).to be_successful
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it 'returns two products when min_posted_date is set' do
      get :search, params: { min_posted_date: 1.day.ago }
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'returns one product when max_posted_date is set' do
      get :search, params: { max_posted_date: 1.day.ago }
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it 'returns one product when min_posted_date and max_posted_date are set' do
      get :search, params: { min_posted_date: 2.days.ago, max_posted_date: 1.day.ago }
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it 'returns a 400 response when min_posted_date is invalid' do
      get :search, params: { min_posted_date: 'invalid' }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to eq('invalid date')
    end

    it 'returns two products when min_price and max_price are set' do
      get :search, params: { min_price: 200, max_price: 300 }
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'returns two products when min_price is set' do
      get :search, params: { min_price: 200 }
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST #create' do
    it 'returns a success response' do
      post :create, params: { product: { name: 'Product 4', price: 400, status: 'active' } }
      expect(response).to be_successful
    end

    it 'creates a new product' do
      expect do
        post :create, params: { product: { name: 'Product 4', price: 400, status: 'active' } }
      end.to change(Product, :count).by(1)
    end
  end

  describe 'PUT #update' do
    it 'returns a success response' do
      put :update, params: { id: Product.first.id, product: { status: 'inactive' } }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['status']).to eq('inactive')
    end
  end

  describe 'DELETE #destroy' do
    it 'returns a success response' do
      delete :destroy, params: { id: Product.first.id }
      expect(response).to be_successful
    end

    it 'deletes a product' do
      expect do
        delete :destroy, params: { id: Product.first.id }
      end.to change(Product, :count).by(-1)
    end
  end

  describe '#set_product' do
    it 'returns a 404 response when product is not found' do
      get :update, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Product not found')
    end
  end
end
