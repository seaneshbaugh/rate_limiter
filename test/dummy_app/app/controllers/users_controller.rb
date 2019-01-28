# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      flash[:success] = 'User created.'

      redirect_to user_url(@user), status: :see_other
    else
      flash[:error] = "User not created. #{@user.errors.full_messages.join('. ')}."

      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'User updated.'

      redirect_to user_url(@user), status: :see_other
    else
      flash[:error] = "User not updated. #{@user.errors.full_messages.join('. ')}."

      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    flash[:success] = 'User destroyed.'

    redirect_to users_url, status: :see_other
  end

  private

  def set_user
    @user = User.where(id: params[:id]).first

    raise ActiveRecord::RecordNotFound if @user.nil?
  end

  def user_params
    params.required(:user).permit(:email)
  end
end
