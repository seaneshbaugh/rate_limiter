# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user, inverse_of: :messages

  validates :subject, presence: true
  validates :body, presence: true
  validates :ip_address, presence: true

  rate_limit on: :ip_address, interval: 1.minute
end
