# frozen_string_literal: true

class User < ApplicationRecord # rubocop:disable Style/Documentation
  has_secure_password
  has_many :assignments
  has_many :tasks

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
