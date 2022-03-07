class Booking < ApplicationRecord
  belongs_to :house
  belongs_to :user
  delegate :tribe, to: :user

  validates :arrival, :departure, :status, presence: true

  enum status: {
    pending: 0,
    validated: 1,
    declined: 2
  }
  scope :pending, -> { where(status: :pending) }
  scope :validated, -> { where(status: :validated) }
  scope :declined, -> { where(status: :declined) }

  before_create :booking_adjust
  before_save :booking_price_calculate
  before_update :booking_update

  def booking_update
    # self.errors.add
    # faire le check sur les crédits suffisants à 2 endroits...
    return unless validated?

    if status_changed?
      # Booking has just been validated: we decrease tribe credits
      user.tribe.credits -= total_price
      user.tribe.save
    end

    return unless arrival_changed? || departure_changed?

    update_column(:status, "pending")
    # Booking was validated before the update and booking dates have just been changed: we reimburse credits
    user.tribe.credits += total_price_changed? ? total_price_change[0] : total_price
    user.tribe.save
  end

  def booking_adjust
    booking_price_calculate
    return unless user.admin?

    return unless user.tribe.credits >= total_price

    self.status = "validated"
    user.tribe.credits -= total_price
    user.tribe.save
  end

  def booking_price_calculate
    self.total_price = nb_days * house.daily_price
  end

  def nb_days
    (departure - arrival).to_i + 1
  end
end
