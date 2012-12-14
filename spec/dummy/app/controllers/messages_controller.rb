class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.where(:id => params[:id]).first

    if @message.nil?
      flash[:error] = 'Could not find the specified message.'

      redirect_to messages_url
    end
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])

    @message.ip_address = request.remote_ip

    if @message.save
      flash[:success] = 'Message has been saved.'

      redirect_to messages_url
    else
      render 'new'
    end
  end

  def edit
    @message = Message.where(:id => params[:id]).first

    if @message.nil?
      flash[:error] = 'Could not find the specified message.'

      redirect_to messages_url
    end
  end

  def update
    @message = Message.where(:id => params[:id]).first

    if @message.nil?
      flash[:error] = 'Could not find the specified message.'

      redirect_to messages_url
    end

    if @message.update_attributes(params[:message])
      flash[:success] = 'Message has been updated.'

      redirect_to messages_url
    else
      render 'edit'
    end
  end

  def destroy
    @message = Message.where(:id => params[:id]).first

    if @message.nil?
      flash[:error] = 'Could not find the specified message.'

      redirect_to messages_url
    end

    @message.destroy

    redirect_to messages_url
  end
end
