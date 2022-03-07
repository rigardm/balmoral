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

  before_save :booking_adjust

  def booking_adjust
    self.total_price = nb_days * house.daily_price
    self.status = "validated" if user.admin?
    user.tribe.credits -= total_price
    user.tribe.save
  end

  def nb_days
    (departure - arrival).to_i + 1
  end
end
