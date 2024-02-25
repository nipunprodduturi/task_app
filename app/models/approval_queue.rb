# frozen_string_literal: true

# The ApprovalQueue model is used to store the approval queue for the products.
class ApprovalQueue < ApplicationRecord
  belongs_to :product

  validates :action, inclusion: { in: %w[approve reject] }
end
