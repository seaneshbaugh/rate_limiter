class Message < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :subject, :body, :ip_address

  rate_limit :on => :ip_address, :interval => 1.minute
end
