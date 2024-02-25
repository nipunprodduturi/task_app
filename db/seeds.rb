# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create 10 different tasks
10.times do
  Task.create(
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph,
    due_date: Faker::Date.forward(days: 30),
    status: %w[pending in_progress completed].sample,
    progress: rand(0..100),
    priority: %w[low medium high].sample
  )
end

2.times do
  Task.update(
    completed_date: Faker::Date.backward(days: 30)
  )
end

User.create(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123'
)

User.create(
  name: 'Jane Smith',
  email: 'jane@example.com',
  password: 'password456'
)

# Create products
Product.create(name: 'Product 1', price: 100, status: 'active')
Product.create(name: 'Product 2', price: 200, status: 'active')
Product.create(name: 'Product 3', price: 300, status: 'inactive')

# Create product queues
ApprovalQueue.create(product: Product.first, action: 'approve')
ApprovalQueue.create(product: Product.second, action: 'reject')
