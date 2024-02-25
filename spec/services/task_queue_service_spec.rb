# frozen_string_literal: true

# spec/services/task_queue_service_spec.rb

require 'rails_helper'

RSpec.describe TaskQueueService do
  describe '.next_task' do
    context 'when there are tasks in the queue' do
      let!(:high_priority_task) { create(:task, priority: 'high', due_date: 1.day.from_now) }
      let!(:medium_priority_task) { create(:task, priority: 'medium', due_date: 2.days.from_now) }
      let!(:low_priority_task) { create(:task, priority: 'low', due_date: 3.days.from_now) }

      it 'returns the next task in the queue based on priority and due date' do
        expect(TaskQueueService.next_task).to eq(high_priority_task)
      end
    end

    context 'when the queue is empty' do
      it 'returns nil' do
        expect(TaskQueueService.next_task).to be_nil
      end
    end
  end
end
