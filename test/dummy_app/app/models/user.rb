# frozen_string_literal: true

class User < ApplicationRecord
  has_many :messages

  validates :email, presence: true
end
