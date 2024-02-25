# frozen_string_literal: true

class AddPriorityToTaskTable < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    add_column :tasks, :priority, :string
  end
end
