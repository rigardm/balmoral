class BookingsController < ApplicationController

  before_action :set_booking, except: %i[index new create]
  before_action :set_house, only: %i[index new create]

  def index
    @bookings = policy_scope(Booking).order(arrival: :asc)
  end

  def show
  end

  def new
    @booking = Booking.new
    @booking.house = @house
    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.house = @house
    @booking.user = current_user
    # total_price = @booking.nb_days * @house.daily_price
    # @booking.total_price = total_price
    # @booking.status = "validated" if current_user.admin?
    authorize @booking
    if @booking.save
      # @booking.user.tribe.credits -= total_price
      # @booking.user.tribe.save
      redirect_to calendar_path(@house)
    else
      render :new
    end
  end

  def edit
  end

  def update
    previous_price = @booking.total_price
    @booking.update(booking_params)
    total_price = @booking.nb_days * @booking.house.daily_price
    @booking.total_price = total_price
    if @booking.save
      current_user.tribe.credits += previous_price
      current_user.tribe.credits -= total_price
      current_user.tribe.save
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @house = @booking.house
    previous_price = @booking.total_price
    @booking.destroy
    current_user.tribe.credits += previous_price
    current_user.tribe.save
    redirect_to root_path
  end

  # Simple_Calendar a besoin d'un "start_time" et "end_time"
  def start_time
    arrival
  end

  def end_time
    departure
  end

  def find_booking
    respond_to do |format|
      format.json do
        html = render_to_string(
          partial: "shared/booking_preview",
          locals: { booking: @booking }, layout: false, formats: [:html]
        )
        render json: { html: html }
      end
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def set_house
    @house = House.find(params[:house_id])
  end

  def booking_params
    params.require(:booking).permit(:arrival, :departure)
  end
end
