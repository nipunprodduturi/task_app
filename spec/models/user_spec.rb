# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:tasks) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'password encryption' do
    let(:user) { create(:user, password: 'password123', password_confirmation: 'password123') }

    it 'encrypts the password' do
      expect(user.authenticate('password123')).to eq(user)
      expect(user.authenticate('wrongpassword')).to be false
    end
  end
end
