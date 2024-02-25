# frozen_string_literal: true

class Task < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :user

  enum status: { pending: 'Pending', in_progress: 'In Progress', completed: 'Completed' }
  enum priority: { low: 'Low', medium: 'Medium', high: 'High' }

  validates :title, presence: true
  validates :due_date, presence: true
end
