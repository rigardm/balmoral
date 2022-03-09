class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    return unless user_signed_in?

    @house = current_user.house
    @your_bookings = policy_scope(Booking).where('arrival > ? AND user_id = ?', DateTime.now, current_user.id).order(created_at: :desc).limit(3)
    @next_bookings = policy_scope(Booking).order(arrival: :asc).where('arrival > ?', DateTime.now).limit(3)
    @tribes = @house.tribes.order(created_at: :asc)
    return unless current_user.admin?

    @bookings_to_validate = policy_scope(Booking).pending.joins(:user).where(user: { tribe: current_user.tribe }).order(created_at: :desc)
  end
end
