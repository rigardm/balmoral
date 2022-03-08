class SpendingsController < ApplicationController

  def index
    @house = current_user.house
    @spendings = policy_scope(Spending).order(date: :desc)
  end

  def balances
    @house = current_user.house
    @balance_per_tribe = @house.balance_per_tribe
    @spendings_per_tribe = @house.spending_per_tribe

    authorize :spending, :balances?
  end
end
