# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_223_191_616) do
  create_table 'approval_queues', force: :cascade do |t|
    t.integer 'product_id'
    t.string 'action'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_approval_queues_on_product_id'
  end

  create_table 'assignments', force: :cascade do |t|
    t.integer 'task_id', null: false
    t.integer 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['task_id'], name: 'index_assignments_on_task_id'
    t.index ['user_id'], name: 'index_assignments_on_user_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name'
    t.decimal 'price'
    t.string 'status'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'tasks', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.datetime 'due_date'
    t.string 'status'
    t.datetime 'completed_date'
    t.integer 'progress'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'priority'
    t.integer 'user_id'
    t.index ['user_id'], name: 'index_tasks_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'password_digest'
  end

  add_foreign_key 'approval_queues', 'products'
  add_foreign_key 'assignments', 'tasks'
  add_foreign_key 'assignments', 'users'
  add_foreign_key 'tasks', 'users'
end
