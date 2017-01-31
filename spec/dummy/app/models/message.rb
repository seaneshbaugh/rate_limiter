class Message < ApplicationRecord
  rate_limit on: :ip_address, interval: 1.minute
end
