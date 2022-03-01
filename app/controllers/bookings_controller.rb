class BookingsController < ApplicationController

  before_action :set_booking, except: %i[index new create]
  before_action :set_house, only: %i[index new create]

  def index
    @bookings = @house.bookings
  end

  def show
  end

  def new
    @booking = Booking.new
  end

  def create
  end

  def edit
  end

  def update
    @booking = Booking.update(booking_params)
    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :edit
    end
  end

  def destroy
    @house = @booking.house
    @booking.destroy
    redirect_to house_bookings_path(@house)
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_house
    @house = House.find(params[:house_id])
  end

  def booking_params
    params.require(:booking).permit(:arrival, :departure, :status)
  end
end
