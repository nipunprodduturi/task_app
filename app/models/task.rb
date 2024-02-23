# frozen_string_literal: true

class Task < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :user
  has_many :assignments
  enum status: { pending: 'Pending', in_progress: 'InProgress', completed: 'Completed' }
  enum priority: { low: 'Low', medium: 'Medium', high: 'High' }

  validates :title, presence: true
  validates :due_date, presence: true
end
