class BookingsController < ApplicationController

  before_action :set_booking, except: %i[index new create]
  before_action :set_house, only: %i[index new create]

  def index
    @bookings = policy_scope(Booking).order(created_at: :desc)
  end

  def show
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.house = @house
    @booking.user = current_user
    if @booking.save
      redirect_to house_bookings_path(@house)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @booking.update(booking_params)
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
    params.require(:booking).permit(:arrival, :departure)
  end
end
