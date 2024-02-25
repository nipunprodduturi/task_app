# frozen_string_literal: true

# spec/models/product_spec.rb

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_less_than_or_equal_to(10_000) }
    it { should validate_presence_of(:status) }
  end

  describe 'scopes' do
    describe '.active' do
      let!(:active_product) { create(:product, status: 'active') }
      let!(:inactive_product) { create(:product, status: 'inactive') }

      it 'returns only active products' do
        expect(Product.active).to include(active_product)
        expect(Product.active).not_to include(inactive_product)
      end
    end
  end
end
