# frozen_string_literal: true

class SessionsController < ApplicationController
  include RequireCurrentUser

  before_action :require_current_user, only: %i[destroy]

  def create
    @user = User.where(email: params[:email]).first

    if @user.present?
      session[:current_user] = @user.id

      flash[:success] = 'Logged in.'
    else
      flash[:error] = 'Invalid email address.'
    end

    redirect_to root_url
  end

  def destroy
    session.delete(:current_user)

    flash[:success] = 'Logged out.'

    redirect_to root_url
  end
end
