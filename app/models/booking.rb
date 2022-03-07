class Booking < ApplicationRecord
  belongs_to :house
  belongs_to :user
  delegate :tribe, to: :user

  validates :arrival, :departure, :status, presence: true

  enum status: {
    pending: 0,
    validated: 1,
    declined: 2,
    cancelled: 3
  }
  scope :pending, -> { where(status: :pending) }
  scope :validated, -> { where(status: :validated) }
  scope :declined, -> { where(status: :declined) }
  scope :cancelled, -> { where(status: :cancelled) }

  before_create :create_booking_check
  after_create :validated_status_for_admin
  before_update :update_booking_check
  before_destroy :destroy_booking_check

  def validated_status_for_admin
    update_column(:status, "validated") if user.admin?
  end

  def create_booking_check
    self.total_price = nb_days * house.daily_price
    if total_price > user.tribe.credits
      errors.add("Crédits insuffisants pour cette réservation")
    elsif user.admin?
      # update_column(:status, "validated")
      user.tribe.credits -= total_price
      user.tribe.save
    end
  end

  def update_booking_check
    if arrival_changed? || departure_changed?
      # booking is either pending or validated
      if pending? && total_price > user.tribe.credits
        errors.add("Crédits insuffisants pour cette réservation")
      elsif validated?
        if total_price_changed?
          if (total_price_change[1] - total_price_change[0]) > user.tribe.credits
            errors.add("Crédits insuffisants pour cette modification")
          elsif user.admin?
            user.tribe.credits -= (total_price_change[1] - total_price_change[0])
            user.tribe.save
          else
            update_column(:status, "pending")
            user.tribe.credits += total_price_change[0]
            user.tribe.save
          end
        elsif user.member?
          # total_price remains unchanged (booking has same nb of days)
          update_column(:status, "pending")
          user.tribe.credit += total_price
          user.tribe.save
        end
      end
    elsif validated?
      if total_price > user.tribe.credits
        errors.add("Crédits insuffisants pour cette réservation")
      else
        user.tribe.credits -= total_price
        user.tribe.save
      end
    end
  end

  def destroy_booking_check
    return unless validated?

    user.tribe.credits += total_price
    user.tribe.save
  end

  def nb_days
    (departure - arrival).to_i + 1
  end
end
