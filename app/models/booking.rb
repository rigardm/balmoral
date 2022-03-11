class Booking < ApplicationRecord
  belongs_to :house
  belongs_to :user, optional: true
  belongs_to :platform, optional: true
  delegate :tribe, to: :user

  before_create :create_booking_check
  after_create :validated_status_for_admins_and_platforms
  before_update :update_booking_check
  before_destroy :destroy_booking_check

  validate :credits_must_be_sufficient

  validates :arrival, :departure, :status, presence: true
  validates :user, presence: true, unless: :platform?
  validates :platform, presence: true, unless: :user?

  scope :pending, -> { where(status: :pending) }
  scope :validated, -> { where(status: :validated) }
  scope :declined, -> { where(status: :declined) }
  scope :not_declined, -> { where.not(status: :declined) }

  enum status: {
    pending: 0,
    validated: 1,
    declined: 2
  }

  def platform?
    platform.present?
  end

  def user?
    user.present?
  end

  def validated_status_for_admins_and_platforms
    update_column(:status, "validated") if (user? && user.admin?) || platform?
  end

  def create_booking_check
    return if platform?
    return unless user.admin?

    set_total_price
    credit_decrease(total_price)
  end

  def update_booking_check
    if status_changed?
      set_total_price
      credit_decrease(total_price) if validated? && credits_are_sufficient?
    elsif declined?
      update_column(:status, "pending") if credits_must_be_sufficient
    elsif validated?
      if total_price_changed?
        if (total_price_change[1] - total_price_change[0]) > user.tribe.credits
          errors.add("Crédits insuffisants pour cette modification")
        elsif user.admin?
          credit_increase(total_price_change[0])
          credit_decrease(total_price_change[1])
        elsif user.member?
          update_column(:status, "pending")
          credit_increase(total_price_change[0])
        end
      elsif user.member?
        update_column(:status, "pending")
      end
    end
  end

  def destroy_booking_check
    return unless user?
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

  def credit_decrease(number)
    user.tribe.credits -= number
    user.tribe.save
  end

  def credit_increase(number)
    user.tribe.credits += number
    user.tribe.save
  end

  def credits_must_be_sufficient
    return if credits_are_sufficient?

    errors.add("Crédits insuffisants pour cette réservation")
  end

  def credits_are_sufficient?
    return true unless user.present?

    set_total_price
    return true unless user.tribe.credits < total_price

    return false
  end
end
