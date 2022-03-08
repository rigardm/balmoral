class SpendingsController < ApplicationController

  def index
    @house = current_user.house
    @spendings = policy_scope(Spending).order(date: :desc)
    @spending = Spending.new
  end

  def balances
    @house = current_user.house
    @balance_per_tribe = @house.balance_per_tribe
    @spendings_per_tribe = @house.spending_per_tribe

    authorize :spending, :balances?
  end

  def create
    @spending = Spending.new(spending_params)
    @spending.tribe = current_user.tribe
   if @spending.save
    redirect_to house_spendings_path
   end

    authorize @spending
  end

  private

  def spending_params
    params.require(:spending).permit(:amount, :name, :category, :date, :details)
  end
end
