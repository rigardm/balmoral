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
    authorize @booking
    if @booking.save
      send_message("By Jove!! #{current_user.first_name} a réservé du #{@booking.arrival} au #{@booking.departure}!!")
      redirect_to calendar_path(@house, params: { start_date: @booking.arrival.to_s })
    else
      render :new
    end
  end

  def admin_denial
    @booking.declined! if @booking.pending?
    send_message("Damned!! la réservation de #{@booking.first_name} du #{@booking.arrival} au #{@booking.departure} a été refusée par #{@booking.user.tribe.admin.first_name}!!")
    redirect_to root_path
  end

  def admin_validation
    @booking.validated! if @booking.pending?
    send_message("Heavens!! la réservation de #{@booking.first_name} du #{@booking.arrival} au #{@booking.departure} a été validée par #{@booking.user.tribe.admin.first_name}!!")
    redirect_to root_path
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @booking.destroy
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
          partial: "shared/simple_booking_modal",
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

  def send_message(content)
    @message = Message.new(content: content)
    authorize @message
    @channel = @house.channels.last
    @message.channel = @channel
    @message.user = User.find(1)
    @message.save
  end
