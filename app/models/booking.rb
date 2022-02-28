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
end
