# frozen_string_literal: true

FactoryBot.define do
  factory :approval_queue do
    product { create(:product) }
    action { %w[approve reject].sample }
  end
end
