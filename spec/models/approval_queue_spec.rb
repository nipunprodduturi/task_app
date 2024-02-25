# spec/models/approval_queue_spec.rb

require 'rails_helper'

RSpec.describe ApprovalQueue, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:action).in_array(%w[approve reject]) }
  end
end
