class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = Message.all
  end

  def show; end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    @message.ip_address = request.remote_ip

    if @message.save
      flash[:success] = 'Message has been saved.'

      redirect_to messages_url
    else
      flash.now[:error] = @message.errors.full_messages.uniq.join('. ') + '.'

      render 'new'
    end
  end

  def edit; end

  def update
    if @message.update_(message_params)
      flash[:success] = 'Message has been updated.'

      redirect_to messages_url
    else
      flash.now[:error] = @message.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def destroy
    @message.destroy

    flash[:success] = 'Message has been deleted.'

    redirect_to messages_url
  end

  private

  def set_message
    @message = Message.where(id: params[:id]).first

    raise ActiveRecord::RecordNotFound if @message.nil?
  end

  def message_params
    params.require(:message).permit(:first_name, :last_name, :subject, :body)
  end
end
