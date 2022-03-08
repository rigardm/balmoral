class Booking < ApplicationRecord
  belongs_to :house
  belongs_to :user
  delegate :tribe, to: :user

  validates :arrival, :departure, :status, presence: true
  validate :credits_must_be_sufficient

  enum status: {
    pending: 0,
    validated: 1,
    declined: 2
  }
  scope :pending, -> { where(status: :pending) }
  scope :validated, -> { where(status: :validated) }
  scope :declined, -> { where(status: :declined) }

  before_create :create_booking_check
  after_create :validated_status_for_admin
  before_update :update_booking_check
  before_destroy :destroy_booking_check

  def validated_status_for_admin
    update_column(:status, "validated") if user.admin?
  end

  def create_booking_check
    credits_must_be_sufficient
    return unless credits_are_sufficient? && user.admin?

    user.tribe.credits -= total_price
    user.tribe.save
  end

  def update_booking_check
    if pending? || declined?
      # booking is either pending and dates have changed
      credits_must_be_sufficient
    elsif total_price_changed?
      # booking is validated and price has changed
      if (total_price_change[1] - total_price_change[0]) > user.tribe.credits
        errors.add("Crédits insuffisants pour cette modification")
      elsif user.admin?
        user.tribe.credits -= (total_price_change[1] - total_price_change[0])
        user.tribe.save
      elsif user.member?
        update_column(:status, "pending")
        user.tribe.credits += total_price_change[0]
        user.tribe.save
      end
    elsif user.member?
      # booking is validated, total_price has not changed but dates have changed (booking has same nb of days)
      update_column(:status, "pending")
      user.tribe.credits += total_price
      user.tribe.save
    elsif status_changed?
      # user is admin and is validating a pending booking
      credits_must_be_sufficient
      if credits_are_sufficient?
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

  private

  def set_total_price
    self.total_price = nb_days * house.daily_price
  end

  def credits_are_sufficient?
    set_total_price
    user.tribe.credits >= total_price
  end

  def credits_must_be_sufficient
    set_total_price
    errors.add("Crédits insuffisants pour cette réservation") if user.tribe.credits < total_price
  end
end
