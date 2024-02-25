# frozen_string_literal: true

# The product model has a status field that can be either active or inactive.
class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { less_than_or_equal_to: 10_000 }
  validates :status, presence: true

  scope :active, -> { where(status: 'active') }
end
