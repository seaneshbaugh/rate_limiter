# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_current_user

  attr_reader :current_user
  helper_method :current_user

  private

  def set_current_user
    return unless session[:current_user].present?

    @current_user = User.where(id: session[:current_user]).first

    session.delete(:current_user) unless @current_user.present?
  end
end
