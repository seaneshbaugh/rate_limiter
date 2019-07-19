# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = find_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      flash[:success] = 'User created.'

      redirect_to user_url(@user), status: :see_other
    else
      flash.now[:error] = "User not created. #{@user.errors.full_messages.join('. ')}."

      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = find_user
  end

  def update
    @user = find_user

    if @user.update(user_params)
      flash[:success] = 'User updated.'

      redirect_to user_url(@user), status: :see_other
    else
      flash.now[:error] = "User not updated. #{@user.errors.full_messages.join('. ')}."

      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user = find_user

    @user.destroy

    flash[:success] = 'User destroyed.'

    redirect_to users_url, status: :see_other
  end

  private

  def find_user
    User.find_by!(id: params[:id])
  end

  def user_params
    params.required(:user).permit(:email)
  end
end
