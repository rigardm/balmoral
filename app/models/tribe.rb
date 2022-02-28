class Tribe < ApplicationRecord
  belongs_to :house
  has_many :users, dependent: :destroy
  has_many :members, -> { where(role: :member) }, through: :tribes, source: :users
  has_many :spendings, dependent: :destroy
  has_many :bookings, through: :users

  validates :color, :credits, presence: true
  validates :color, uniqueness: { scope: :house }

  def admin
    users.find_by(role: :admin)
  end
end
