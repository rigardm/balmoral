class Tribe < ApplicationRecord
  belongs_to :house
  has_many :users, dependent: :destroy
  has_many :members, -> { where(role: :member) }, through: :tribes, source: :users
  has_many :spendings, dependent: :destroy
  has_many :bookings, through: :users

  validates :color, presence: true, uniqueness: { scope: :house }
  validates :credits, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def admin
    users.find_by(role: :admin)
  end
end
