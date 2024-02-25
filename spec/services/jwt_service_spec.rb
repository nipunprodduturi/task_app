# frozen_string_literal: true

# spec/services/jwt_service_spec.rb

require 'rails_helper'

RSpec.describe JwtService do
  let(:payload) { { user_id: 1 } }
  let(:token) { JwtService.encode(payload) }

  describe '.encode' do
    it 'encodes the payload into a JWT token' do
      expect(JwtService.encode(payload)).to be_a(String)
    end
  end

  describe '.decode' do
    it 'decodes the JWT token into a payload' do
      decoded_payload = JwtService.decode(token)
      expect(decoded_payload).to eq(payload.with_indifferent_access)
    end
  end
end
