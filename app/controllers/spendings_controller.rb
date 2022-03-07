class SpendingsController < ApplicationController

  def index
    @house = current_user.house
    @spendings = policy_scope(Spending).order(created_at: :asc)
  end

  def balances
    @house = current_user.house
    @tribes_datas = @house.spending_per_tribe

    authorize :spending, :balances?
  end
end
