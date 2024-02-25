# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :due_date
      t.string :status
      t.datetime :completed_date
      t.integer :progress

      t.timestamps
    end
  end
end
