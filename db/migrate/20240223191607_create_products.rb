# frozen_string_literal: true

# Version: 0.0.1
class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.string :status

      t.timestamps
    end
  end
end
