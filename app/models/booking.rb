class Booking < ApplicationRecord
  belongs_to :house
  belongs_to :user

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
