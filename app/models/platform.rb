class Platform < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_one_attached :photo

  validates :name, presence: true, uniqueness: true
end
