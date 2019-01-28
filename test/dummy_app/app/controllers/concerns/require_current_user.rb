# frozen_string_literal: true

module RequireCurrentUser
  extend ActiveSupport::Concern

  def require_current_user
    return if current_user.present?

    flash[:error] = 'You must be logged in to perform this action.'

    redirect_to root_url
  end
end
