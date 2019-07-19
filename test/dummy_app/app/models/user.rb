# frozen_string_literal: true

class User < ApplicationRecord
  has_many :messages, dependent: :destroy, inverse_of: :user

  validates :email, presence: true
end
