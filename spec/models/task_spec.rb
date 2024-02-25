# frozen_string_literal: true

# spec/models/task_spec.rb

require 'rails_helper'

RSpec.describe Task, type: :model do
  subject { create(:task) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'enums' do
    context 'status' do
      it 'has the correct statuses' do
        expect(Task.statuses).to eq('pending' => 'Pending', 'in_progress' => 'In Progress', 'completed' => 'Completed')
      end
    end

    context 'priority' do
      it 'has the correct priorities' do
        expect(Task.priorities).to eq('low' => 'Low', 'medium' => 'Medium', 'high' => 'High')
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:due_date) }
  end
end
