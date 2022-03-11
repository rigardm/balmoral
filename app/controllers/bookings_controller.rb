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
      send_message("By Jove! #{current_user.first_name} a réservé du #{@booking.arrival.strftime('%d/%m')} au #{@booking.departure.strftime('%d/%m')} !")
      flash[:notice] = "By Jove!! <br> Votre réservation est créée et en attente de validation" if @booking.pending?
      flash[:notice] = "Hurrah!! <br> Votre réservation est validée" if @booking.validated?
      redirect_to calendar_path(@house, params: { start_date: @booking.arrival.to_s })
    else
      render :new
    end
  end

  def admin_denial
    @booking.declined! if @booking.pending?
    send_message("Damned!! La réservation de #{@booking.user.first_name} du #{@booking.arrival.strftime('%d/%m')} au #{@booking.departure.strftime('%d/%m')} a été refusée par #{@booking.user.tribe.admin.first_name}!!")
    flash[:notice] = "Damned!! <br> La réservation est refusée" if @booking.declined?
    redirect_to root_path
  end

  def admin_validation
    @booking.validated! if @booking.pending?
    send_message("Heavens!! La réservation de #{@booking.user.first_name} du #{@booking.arrival.strftime('%d/%m')} au #{@booking.departure.strftime('%d/%m')} a été validée par #{@booking.user.tribe.admin.first_name}!!")
    flash[:notice] = "Heavens!! <br> La réservation est validée" if @booking.validated?
    redirect_to root_path
  end

  def edit
  end

  def update
    @house = @booking.house
    if @booking.update(booking_params)
      flash[:notice] = "All Right! <br> Réservation mise à jour"
      redirect_to root_path
    else
      flash[:notice] = "Hell!! <br> Pas assez de crédits pour modifier la réservation"
      redirect_to calendar_path(@house, params: { start_date: @booking.arrival.to_s })
    end
  end

  def destroy
    flash[:notice] = "Farewell..." if @booking.destroy
    redirect_to root_path
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

  def send_message(content)
    @message = Message.new(content: content)
    @message.channel = @booking.house.channels.last
    @message.user = User.find_by(last_name: 'System-Bot')
    @message.save
  end
end
