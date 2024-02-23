# frozen_string_literal: true

class Assignment < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :user
  belongs_to :task
end
