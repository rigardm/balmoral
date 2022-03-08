class Platform < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
