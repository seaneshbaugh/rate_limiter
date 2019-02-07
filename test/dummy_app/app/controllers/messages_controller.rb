# frozen_string_literal: true

class MessagesController < ApplicationController
  include RequireCurrentUser

  before_action :require_current_user, only: %i[new create edit update destroy]
  before_action :set_message, only: %i[show edit update destroy]

  def index
    @messages = Message.all
  end

  def show; end

  def new
    @message = Message.new
  end

  def create
    @message = Message.create(message_params_with_current_user)

    if @message.save
      flash[:success] = 'Message created.'

      redirect_to message_url(@message), status: :see_other
    else
      flash[:error] = "Message not created. #{@message.errors.full_messages.join('. ')}."

      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @message.update(message_params)
      flash[:success] = 'Message updated.'

      redirect_to message_url(@message), status: :see_other
    else
      flash[:error] = "Message not updated. #{@message.errors.full_messages.join('. ')}."

      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy

    flash[:success] = 'Message destroyed.'

    redirect_to messages_url, status: :see_other
  end

  private

  def set_message
    @message = Message.where(id: params[:id]).first

    raise ActiveRecord::RecordNotFound if @message.nil?
  end

  def message_params
    params.required(:message).permit(:subject, :body)
  end

  def message_params_with_current_user
    message_params.merge(user: current_user, ip_address: request.remote_ip)
  end
end
