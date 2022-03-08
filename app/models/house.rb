class House < ApplicationRecord
  has_many :tribes, dependent: :destroy
  has_many :users, through: :tribes
  has_many :admins, -> { where(role: :admin) }, through: :tribes, source: :users
  has_many :members, -> { where(role: :member) }, through: :tribes, source: :users
  has_many :spendings, through: :tribes
  has_many :bookings, dependent: :destroy
  has_many :channels, dependent: :destroy
  has_one_attached :photo

  validates :name, :daily_price, :address, :city, presence: true
  validates :daily_price, numericality: { greater_than_or_equal_to: 0 }

  def spending_per_tribe
    result = {}
    tribes.each do |tribe|
      result[tribe.admin.first_name] = spendings.where(tribe: tribe).sum(&:amount)
    end
    result
  end

  def balance_per_tribe
    result = {}
    tribes.each do |tribe|
      result[tribe.admin.first_name] = spendings.where(tribe: tribe).sum(&:amount) - (spendings.sum(&:amount) * tribe.shareholding)
    end
    result
  end
end
