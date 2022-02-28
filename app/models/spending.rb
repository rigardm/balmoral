class Spending < ApplicationRecord
  belongs_to :tribe

  validates :amount, :name, :category, :date, presence: true
end
