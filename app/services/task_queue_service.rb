# frozen_string_literal: true

# TaskQueueService is a service class that is responsible for returning the next task in the queue.
# This class is used to return the next task in the queue.
class TaskQueueService
  def self.next_task
    Task.order(priority: :asc, due_date: :asc).first
  end
end
