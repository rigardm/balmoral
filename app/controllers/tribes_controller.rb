class TribesController < ApplicationController
  before_action :set_house, only: %i[index new create]

  def index
    @tribes = Tribe.all
  end

  def show
    @tribe = Tribe.find(params[:id])
  end

  def new
    @tribe = Tribe.new
  end

  def create
    @tribe = Tribe.new(tribe_params)
    @tribe.house = @house
    if @tribe.save
      redirect_to house_path(@house)
    else
      render 'new'
    end
  end

  private

  def set_house
    @house = House.find(params[:house_id])
  end

  def tribe_params
    params.require(:tribe).permit(:color, :credits, :shareholding, :name)
  end
end
