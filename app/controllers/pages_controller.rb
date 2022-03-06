class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if user_signed_in?
      @house = current_user.house
      @your_bookings = policy_scope(Booking).where('arrival > ? AND user_id = ?', DateTime.now, current_user.id).order(created_at: :desc).limit(3)
      @next_bookings = policy_scope(Booking).order(arrival: :asc).where('arrival > ?', DateTime.now).limit(3)
      @tribes = @house.tribes.order(created_at: :asc)
    end
  end
end
