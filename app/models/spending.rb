class Spending < ApplicationRecord
  belongs_to :tribe
  delegate :house, to: :tribe

  validates :amount, :name, :category, :date, presence: true

  CATEGORIES = ['Admin', 'Bar', 'Charges', 'Entretien', 'Travaux']
end
