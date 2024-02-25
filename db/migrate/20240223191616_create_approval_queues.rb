# frozen_string_literal: true

# Version: 0.0.1
class CreateApprovalQueues < ActiveRecord::Migration[7.1]
  def change
    create_table :approval_queues do |t|
      t.references :product, foreign_key: true
      t.string :action

      t.timestamps
    end
  end
end
