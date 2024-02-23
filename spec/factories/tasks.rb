# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    due_date { Faker::Date.between(from: Date.today, to: 1.month.from_now) }
    status { %w[pending in_progress completed].sample }
    progress { %w[no_progress some_progress completed].sample }
    priority { %w[low medium high].sample }
    completed_date { nil }
    user_id { create(:user).id }
  end
end
