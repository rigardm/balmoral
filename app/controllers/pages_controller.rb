class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if user_signed_in?
      @house = current_user.house
      @last_bookings = policy_scope(Booking).order(created_at: :desc).limit(3)
      @next_bookings = policy_scope(Booking).order(arrival: :asc).where('arrival > ?', DateTime.now).limit(3)
      @tribes = @house.tribes
    end
  end
end
