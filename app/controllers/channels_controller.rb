class ChannelsController < ApplicationController
  before_action :set_house

  def show
    @channel = Channel.find(params[:id])
    @message = Message.new
    authorize @message
  end

 private

 def set_house
  @house = House.find(params[:house_id])
end

end
