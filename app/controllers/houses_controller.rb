class HousesController < ApplicationController
  before_action :set_house, only: %i[show edit update delete]

  def index
    @house = policy_scope(House)
  end

  def show
  end

  def new
    @house = House.new
    authorize @house
  end

  def create
    @house = House.new(house_params)
    authorize @house
    if @house.save
      redirect_to 'houses'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @house.update(house_params)

    redirect_to house_path(@house)
  end

  def delete
    @house.destroy
  end

  private

  def house_params
    params.require(:house).permit(:name, :daily_price, :address, :city, :country)
  end

  def set_house
    @house = House.find(params[:id])
    authorize @house
  end
end
