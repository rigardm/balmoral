class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages, dependent: :destroy
  has_many :bookings, dependent: :destroy
  belongs_to :tribe
  delegate :house, to: :tribe

  validates :first_name, :role, presence: true

  enum role: {
    member: 0,
    admin: 1
  }
  scope :admins, -> { where(role: :admin) }
  scope :members, -> { where(role: :member) }
end
