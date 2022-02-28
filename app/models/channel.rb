class Channel < ApplicationRecord
  belongs_to :house
  has_many :messages, dependent: :destroy

  validates :name, presence: true
end
