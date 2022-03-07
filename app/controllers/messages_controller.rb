class MessagesController < ApplicationController
  before_action :set_channel
  before_action :set_house

  def new
    @message = Message.new
    authorize @message
  end

  def create
      @message = Message.new(message_params)
      authorize @message
      @message.channel = @channel
      @message.user = current_user
      @message.save
      redirect_to house_channel_path(@house, @channel, :anchor => "last")
  end

  private

  def set_channel
    @channel = Channel.find(params[:channel_id])
  end

  def set_house
    @house = House.find(params[:house_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
